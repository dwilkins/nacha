# frozen_string_literal: true

require 'nacha/formatter/base'
require 'json'

module Nacha
  module Formatter
    class JsonFormatter < Base
      def format
        output = {
          file: file_statistics,
          records: records.map(&:to_h)
        }

        JSON.pretty_generate(output)
      end
    end
  end
end
