# frozen_string_literal: true

require 'nacha/formatter/base'

module Nacha
  module Formatter
    class MarkdownFormatter < Base
      def format
        [
          file_statistics_markdown,
          records_markdown
        ].join("\n")
      end

      private

      def file_statistics_markdown
        stats = file_statistics
        <<~MARKDOWN
          # File Information

          - **File Name:** #{stats[:file_name]}
          - **File Size:** #{stats[:file_size]} bytes
          - **Number of Lines:** #{stats[:number_of_lines]}
          - **Created At:** #{stats[:created_at]}
          - **Modified At:** #{stats[:modified_at]}
          - **Checksum (SHA256):** #{stats[:checksum]}
          - **Number of Filler Lines:** #{stats[:number_of_filler_lines]}
        MARKDOWN
      end

      def records_markdown
        records.map { |record| record_to_markdown(record) }.join("\n")
      end

      def record_to_markdown(record)
        if options[:flavor] == :github
          github_flavored_markdown(record)
        else
          common_mark_markdown(record)
        end
      end

      def common_mark_markdown(record)
        "## #{record.human_name}\n\n" +
          record.fields.map { |name, field| "* **#{name}:** #{field}" }.join("\n")
      end

      def github_flavored_markdown(record)
        "### #{record.human_name}\n\n" \
          "| Field | Value |\n" \
          "|-------|-------|\n" +
          record.fields.map { |name, field| "| #{name} | #{field} |" }.join("\n")
      end
    end
  end
end
