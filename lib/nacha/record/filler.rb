# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/filler_record_type'

module Nacha
  module Record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as a Filler record with a constant value of '9'.
    # @!attribute [rw] filler
    #   @return [String] A field consisting of all '9's to pad a block to 10 lines.
    class Filler < Nacha::Record::Base
      include FillerRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C9', position: 1..1
      nacha_field :filler, inclusion: 'M', contents: "C#{'9' * 93}", position: 2..94
    end
  end
end
