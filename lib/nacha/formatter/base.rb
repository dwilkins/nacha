# frozen_string_literal: true

require 'digest'

module Nacha
  module Formatter
    class Base
      attr_reader :ach_file, :options

      def initialize(ach_file, options = {})
        @ach_file = ach_file
        @options = options
      end

      def records
        @ach_file.records
      end

      def format
        raise NotImplementedError, 'Subclasses must implement a format method'
      end

      private

      def file_statistics
        {
          file_name: options.fetch(:file_name, 'STDIN'),
          file_size: options.fetch(:file_size, 0),
          number_of_lines: options.fetch(:number_of_lines, 0),
          created_at: options.fetch(:created_at, ''),
          modified_at: options.fetch(:modified_at, ''),
          checksum: options.fetch(:checksum, ''),
          number_of_filler_lines: number_of_filler_lines
        }
      end

      def number_of_filler_lines
        records.count { |r| r.is_a?(Nacha::Record::Filler) }
      end

      def preamble
        return '' unless options[:preamble]
        return options[:preamble] unless File.exist?(options[:preamble])

        File.read(options[:preamble])
      end

      def postamble
        return '' unless options[:postamble]
        return options[:postamble] unless File.exist?(options[:postamble])

        File.read(options[:postamble])
      end
    end
  end
end
