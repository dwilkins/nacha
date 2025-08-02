# frozen_string_literal: true

require 'nacha/formatter'

module Nacha
  class AchFile
    attr_reader :records

    def initialize(records, options = {})
      @records = records
      @options = options
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

    def formatter(format)
      Formatter::FormatterFactory.get(format, self, @options)
    end
  end
end
