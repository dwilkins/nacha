require 'optparse' # Ruby's built-in option parser
require 'nacha'    # Load the core nacha gem library

module Nacha
  module CLI
    # The main entry point for the CLI
    def self.run(args)
      options = {} # For any global options or flags

      # Define how options are parsed
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: nacha [command] [options]"
        opts.separator ""
        opts.separator "Commands:"
        opts.separator "  parse <filename>      - Parses a NACHA file and prints summary information."
        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-v", "--version", "Show gem version") do
          puts Nacha::VERSION
          exit
        end

        opts.on("-h", "--help", "Show extensive help (this message)") do
          puts opts
          exit
        end
      end

      # Parse global options first, remaining arguments are for the command
      begin
        parser.order!(args)
      rescue OptionParser::InvalidOption => e
        warn "Error: #{e.message}"
        puts parser
        exit(1)
      end

      command = args.shift # Get the command (e.g., 'parse')

      case command
      when "parse"
        parse_command(args, options)
      when nil # No command provided
        puts parser
        exit(1)
      else
        warn "Unknown command: '#{command}'"
        puts parser
        exit(1)
      end

    rescue => e
      warn "An unexpected error occurred: #{e.message}"
      warn e.backtrace.join("\n") if ENV['DEBUG'] # Show backtrace if DEBUG env var is set
      exit(1)
    end

    private

    # Handles the 'parse' command
    def self.parse_command(args, options)
      filename = args.shift
      unless filename && File.exist?(filename)
        warn "Usage: nacha parse <filename>"
        warn "Error: File not found or not specified for parsing."
        exit(1)
      end

      begin
        nacha_file = Nacha.parse(File.open(filename,'r'))
        puts nacha_file.compact.to_json
      rescue => e
        puts caller
        warn "Error parsing NACHA file: #{e.message}"
        warn "Details: #{e.details}" if e.respond_to?(:details)
        warn "An unexpected error occurred while parsing: #{e.message}"
        exit(1)
      end
    end
  end # module CLI
end # module Nacha
