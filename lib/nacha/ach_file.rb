# frozen_string_literal: true

require 'uri' # Required for URI.regexp
require 'openssl'
require 'httparty'
require 'nacha/formatter'

module Nacha
  # Class for handling ACH files, which can be a URL, a file path, or a string of data.
  # encapsulating the records and handling output
  class AchFile
    TEMPLATES_DIR = File.join(Gem::Specification.find_by_name("nacha").gem_dir,
      "templates").freeze
    HTML_PREAMBLE_FILE = File.join(TEMPLATES_DIR, "html_preamble.html")
    HTML_POSTAMBLE_FILE = File.join(TEMPLATES_DIR, "html_postamble.html")

    attr_reader :raw_input, :input_type, :records, :checksum, :input_source,
                :created_at, :modified_at

    def initialize(input_string)
      @input_type = classify_input(input_string)
      @records = []
      case @input_type
      when 'url'
        @input_source = input_string
        @raw_input = read_url_contents_httparty(input_string)
      when 'filepath'
        raise ArgumentError, "File not found: #{input_string}" unless File.exist?(input_string)

        @input_source = input_string
        @raw_input = File.read(input_string)
      when 'string of data'
        @input_source = "string"
        @raw_input = input_string
      else
        if input_string.respond_to?(:read)
          # If input_string is an IO object (like $stdin), read it directly
          @input_source = "stdin"
          @raw_input = input_string.read
        else
          # Otherwise, treat it as a simple string
          @input_source = "string"
          @raw_input = input_string.to_s
        end
      end
      @checksum = OpenSSL::Digest::SHA256.hexdigest(@raw_input) if @raw_input
    end

    def parse
      @records = Nacha::Parser.new.parse_string(@raw_input)
      self
    end

    def to_ach
      records.map(&:to_ach).join("\n")
    end

    def to_json
      formatter(:json).format
    end

    def to_html
      formatter(:html).format
    end

    def to_markdown
      formatter(:markdown).format
    end

    private

    def formatter_options
      {
        file_name: File.basename(@input_source),
        file_size: @raw_input.size,
        number_of_lines: records.size,
        checksum: @checksum,
        preamble: HTML_PREAMBLE_FILE,
        postamble: HTML_POSTAMBLE_FILE
      }.merge(file_info)
    end

    def file_info
      return {} unless @input_type == 'filepath' && File.exist?(@input_source)

      File.open(@input_source,'r') do |file|
        {
          created_at: file.ctime,
          modified_at: file.mtime,
        }
      end
    end

    def formatter(format)
      Formatter::FormatterFactory.get(format, self, formatter_options)
    end

    # Reads the content of a URL using HTTParty.
    #
    # @param url [String] The URL to read.
    # @return [String, nil] The content of the URL as a string, or nil if an error occurred.
    def read_url_contents_httparty(url)
      response = HTTParty.get(url, timeout: 60) # Set a timeout
      if response.success?
        response.body
      else
        puts "Error: HTTP request failed with status #{response.code} #{response.message} for #{url}"
        nil
      end
    rescue StandardError, HTTParty::Error => err
      # HTTParty wraps various network and HTTP errors
      puts "Error: An unexpected error occurred while reading #{url} - #{err.message}"
    end

    # Classifies an input string as a filepath, URL, or string of data.
    # The classification order is: URL -> Filepath -> String of Data (if >= 94 chars) -> Generic String.
    #
    # @param input_arg [String, Object] The input to classify. It will be converted to a string.
    # @return [String] One of 'url', 'filepath', 'string of data', or 'string'.
    def classify_input(input_arg)
      return 'file' if input_arg.respond_to?(:read)
      # Ensure the input is treated as a string for consistent pattern matching.
      # This handles cases where the input might be a number, nil, etc., by converting them to string.
      input = input_arg.to_s

      # 1. Check for URL
      # URI::DEFAULT_PARSER.make_regexp is the standard way to match URIs according to RFCs.
      # It primarily looks for a scheme (e.g., http://, https://, ftp://, file://).
      # Note: It will typically *not* classify "www.example.com" as a URL without a scheme.
      return 'url' if URI::DEFAULT_PARSER.make_regexp.match?(input)

      # 2. Check for Filepath
      # This is the most complex part due to the variety of path formats (absolute, relative,
      # Windows, Unix-like) and the ambiguity with general strings.
      is_filepath = false

      # A. Absolute Path Patterns:
      #    - Unix-like absolute: `/path/to/file`
      #    - Windows drive letter: `C:\path\to\file` or `C:/path/to/file`
      #    - Windows UNC path: `\\server\share\path`
      #    - Home directory (Unix-like): `~/path/to/file`
      if input =~ %r{
    ^                                        # Start of the string
    (?:                                      # Non-capturing group for different absolute path roots
      /                                      | # Unix-like root (e.g., /usr/local)
      [A-Za-z]:[\\/]                         | # Windows drive letter (e.g., C:\, D:/)
      \\\\(?:[a-zA-Z0-9_.-]+[\\/])+[a-zA-Z0-9_.-]* | # Windows UNC path (e.g., \\server\share\folder or \\server\share)
      ~[\\/]                                   # Unix-like home directory (e.g., ~/documents)
    )
  }x # The 'x' modifier allows whitespace and comments in the regex for readability
        is_filepath = true
      # B. Relative Path Starting with Common Indicators:
      #    - Current directory: `./file` or `.\file`
      #    - Parent directory: `../file` or `..\file`
      elsif input =~ %r{^\.{1,2}[\\/]}
        is_filepath = true
      # C. Path containing separators AND ending with a common file extension:
      #    e.g., "folder/image.jpg", "document.pdf" (if it contains a slash or just "document.pdf")
      #    This handles cases like "my_photo.png" or "data/report.xlsx".
      elsif (input.include?('/') || input.include?('\\')) && input =~ /\.[a-zA-Z0-9]{2,5}$/
        is_filepath = true
      # D. Path with separators and multiple components or ending in a separator:
      #    e.g., "folder/file", "dir1/dir2/file", "dir/subdir/", "/another_folder/"
      #    This tries to identify directory structures.
      elsif (input.include?('/') || input.include?('\\'))
        # Split the path by either / or \ and remove any empty strings that result
        # (e.g., "/a/b" splits to ["", "a", "b"]; rejecting empty ones yields ["a", "b"]).
        segments = input.split(/[\/\\]/).reject(&:empty?)
        if segments.length >= 2 || (segments.length >= 1 && (input.end_with?('/') || input.end_with?('\\')))
          # Classify as filepath if:
          # - It has two or more segments (e.g., "folder/file", "/folder/sub/file").
          # - OR it has at least one segment AND ends with a path separator (e.g., "folder/", "/folder/").
          is_filepath = true
        end
      # E. Simple filename with a common extension, not caught by other rules (e.g., "report.txt")
      # This handles cases like "my_document.docx" which have no directory separators but are filenames.
      elsif input =~ /^[a-zA-Z0-9_.-]+\.[a-zA-Z0-9]{2,5}$/
        # Basic check for "name.ext" pattern, allowing common filename characters.
        is_filepath = true
      end

      if is_filepath
        return 'filepath'
      end

      # 3. Check for "string of data"
      # This is the fallback for anything that isn't clearly a URL or a filepath,
      # AND meets the minimum length requirement as per the problem description.
      if input.length >= 94
        return 'string of data'
      end

      # 4. Default: Just a regular string
      # If it doesn't fit any of the above categories (URL, filepath, long data string),
      # it's considered a generic string (e.g., "Hello World", "short_name", "a_simple_word").
      return 'string'
    end

    # # --- Test Cases ---

    # puts "--- URLs ---"
    # puts "http://example.com                       => #{classify_input("http://example.com")}"
    # puts "https://www.google.com/search?q=ruby+regex => #{classify_input("https://www.google.com/search?q=ruby+regex")}"
    # puts "ftp://user:pass@ftp.example.com/file.txt => #{classify_input("ftp://user:pass@ftp.example.com/file.txt")}"
    # puts "file:///C:/Users/user/Documents/report.pdf => #{classify_input("file:///C:/Users/user/Documents/report.pdf")}"
    # puts "www.example.com                          => #{classify_input("www.example.com")} (Expected: string, as it lacks a scheme for URI.regexp)"

    # puts "\n--- Filepaths ---"
    # puts "/usr/local/bin/myscript.sh               => #{classify_input("/usr/local/bin/myscript.sh")}"
    # puts "C:\\Program Files\\App\\config.ini        => #{classify_input("C:\\Program Files\\App\\config.ini")}"
    # puts "/home/user/documents/report.pdf          => #{classify_input("/home/user/documents/report.pdf")}"
    # puts "relative/path/to/file.txt                => #{classify_input("relative/path/to/file.txt")}"
    # puts "./current_dir_file.log                   => #{classify_input("./current_dir_file.log")}"
    # puts "../parent_dir/other_file.csv             => #{classify_input("../parent_dir/other_file.csv")}"
    # puts "my_document.docx                         => #{classify_input("my_document.docx")}"
    # puts "folder/another_folder/image.png          => #{classify_input("folder/another_folder/image.png")}"
    # puts "just_a_folder_name/                      => #{classify_input("just_a_folder_name/")}"
    # puts "root_dir/                                => #{classify_input("root_dir/")}"
    # puts "C:/                                      => #{classify_input("C:/")}"
    # puts "/                                        => #{classify_input("/")}"
    # puts "\\\\server\\share\\file.txt              => #{classify_input("\\\\server\\share\\file.txt")}"
    # puts "\\\\server\\share\\                     => #{classify_input("\\\\server\\share\\")}"

    # puts "\n--- Strings of Data (>= 94 characters) ---"
    # long_data_string = "This is a very long string that serves as an example of generic data. It must be at least 94 characters long to be classified as 'string of data' by our function. This particular string is precisely 160 characters long. Ruby is fun!"
    # puts "#{long_data_string.slice(0, 50)}... (length #{long_data_string.length}) => #{classify_input(long_data_string)}"

    # long_data_94_chars = "a" * 94 # A string of exactly 94 'a' characters
    # puts "#{long_data_94_chars.slice(0, 50)}... (length #{long_data_94_chars.length}) => #{classify_input(long_data_94_chars)}"

    # puts "\n--- Regular Strings (short, ambiguous) ---"
    # puts "Hello World                              => #{classify_input("Hello World")}"
    # puts "short_string                             => #{classify_input("short_string")}"
    # puts "a_simple_word                            => #{classify_input("a_simple_word")}"
    # puts "12345                                    => #{classify_input("12345")}"
    # puts ""                                       => #{classify_input("")}" # Empty string
    # puts "folder_name_only                         => #{classify_input("folder_name_only")}" # Not a path without separator or extension
    # puts "not_a_path/but_looks_like_it_if_short_and_not_a_file_with_extension => #{classify_input("not_a_path/but_looks_like_it_if_short_and_not_a_file_with_extension")}" # This is still a filepath because of the / and multi-segments logic. This is correct behavior for a path-like string.
  end
end
