# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents a second IAT addenda record
    class SecondIatAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C11', position: 2..3
      nacha_field :originator_name, inclusion: 'M', contents: 'Alphameric', position: 4..38
      nacha_field :originator_street_address, inclusion: 'M', contents: 'Alphameric', position: 39..73
      nacha_field :reserved, inclusion: 'M', contents: 'C              ', position: 74..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
