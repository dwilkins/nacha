# frozen_string_literal: true

require 'nacha/formatter/base'
require 'json'

module Nacha
  module Formatter
    class JsonFormatter < Base
      def format
        output = {
          file: file_statistics,
          records: records.map { |record| record_to_h(record) }
        }

        JSON.pretty_generate(output)
      end

      private

      def record_to_h(record)
        {
          nacha_record_type: record.record_type,
          metadata: {
            klass: record.class.name,
            errors: record.errors,
            line_number: record.line_number,
            original_input_line: record.original_input_line
          }
        }.merge(
          record.fields.keys.to_h do |key|
            [key, field_to_json_output(record.fields[key])]
          end
        )
      end

      def field_to_json_output(field)
        if field.json_output
          # rubocop:disable GitlabSecurity/PublicSend
          field.json_output.reduce(field.raw) do |memo, operation|
            memo&.public_send(*operation)
          end
          # rubocop:enable GitlabSecurity/PublicSend
        else
          field.to_s
        end
      end
    end
  end
end
