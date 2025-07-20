# frozen_string_literal: true

require 'nacha/formatter/json_formatter'
require 'nacha/formatter/html_formatter'
require 'nacha/formatter/markdown_formatter'

module Nacha
  module Formatter
    class FormatterFactory
      def self.get(format, records, options = {})
        case format
        when :json
          JsonFormatter.new(records, options)
        when :html
          HtmlFormatter.new(records, options)
        when :markdown
          MarkdownFormatter.new(records, options)
        else
          raise ArgumentError, "Unknown format: #{format}"
        end
      end
    end
  end
end
