# frozen_string_literal: true

require 'nacha/formatter/base'

module Nacha
  module Formatter
    class HtmlFormatter < Base
      def format
        [
          html_preamble,
          file_statistics_html,
          records_html,
          html_postamble
        ].join("\n")
      end

      private

      def html_preamble
        preamble_content = options.fetch(:preamble, default_preamble)
        if File.exist?(preamble_content)
          File.read(preamble_content)
        else
          preamble_content
        end
      end

      def html_postamble
        postamble_content = options.fetch(:postamble, default_postamble)
        if File.exist?(postamble_content)
          File.read(postamble_content)
        else
          postamble_content
        end
      end

      def file_statistics_html
        stats = file_statistics
        <<~HTML
          <div class="file-statistics">
            <h2>File Information</h2>
            <ul>
              <li><strong>File Name:</strong> #{stats[:file_name]}</li>
              <li><strong>File Size:</strong> #{stats[:file_size]} bytes</li>
              <li><strong>Number of Lines:</strong> #{stats[:number_of_lines]}</li>
              <li><strong>Created At:</strong> #{stats[:created_at]}</li>
              <li><strong>Modified At:</strong> #{stats[:modified_at]}</li>
              <li><strong>Checksum (SHA256):</strong> #{stats[:checksum]}</li>
              <li><strong>Number of Filler Lines:</strong> #{stats[:number_of_filler_lines]}</li>
            </ul>
          </div>
        HTML
      end

      def records_html
        records.map { |record| record_to_html(record) }.join("\n")
      end

      def record_to_html(record)
        record_error_class = record.errors.any? ? 'error' : ''
        field_html = record.fields.values.map { |field| field_to_html(field) }.join

        "<div class=\"nacha-record tooltip #{record.record_type} #{record_error_class}\">" \
          "<span class=\"nacha-record-number\" data-name=\"record-number\">#{Kernel.format('%05d',
            record.line_number)}&nbsp;|&nbsp</span>" \
          "#{field_html}" \
          "<span class=\"record-type\" data-name=\"record-type\">#{record.human_name}</span>" \
          "</div>"
      end

      def field_to_html(field)
        tooltip_text = "<span class=\"tooltiptext\">#{field.human_name} #{field.errors.join(' ')}</span>"
        field_classes = %w[nacha-field tooltip]
        field_classes << 'mandatory' if field.mandatory?
        field_classes << 'required' if field.required?
        field_classes << 'optional' if field.optional?
        field_classes << 'error' if field.errors.any?

        ach_string = field.to_ach.gsub(' ', '&nbsp;')
        "<span data-field-name=\"#{field.name}\" contentEditable=true " \
          "class=\"#{field_classes.join(' ')}\" data-name=\"#{field.name}\">" \
          "#{ach_string}#{tooltip_text}</span>"
      end

      def default_preamble
        stylesheet = options.fetch(:stylesheet, default_stylesheet)
        javascript = options.fetch(:javascript, '')
        <<~HTML
          <!DOCTYPE html>
          <html>
          <head>
            <title>NACHA File</title>
            <style>#{stylesheet}</style>
            <script>#{javascript}</script>
          </head>
          <body>
        HTML
      end

      def default_postamble
        <<~HTML
          </body>
          </html>
        HTML
      end

      def default_stylesheet
        <<~CSS
          body { font-family: monospace; }
          .tooltip { position: relative; display: inline-block; border-bottom: 1px dotted black; }
          .tooltip .tooltiptext { visibility: hidden; width: 120px; background-color: black; color: #fff; text-align: center; border-radius: 6px; padding: 5px 0; position: absolute; z-index: 1; }
          .tooltip:hover .tooltiptext { visibility: visible; }
          .nacha-record { white-space: nowrap; }
          .error { background-color: #ffdddd; }
        CSS
      end
    end
  end
end
