# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base.rb'
require 'nacha/record/detail_record_type.rb'

module Nacha
  module Record
    class IatEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :number_of_addenda_records, inclusion: 'M', contents: 'Alphameric', position: 13..16
      nacha_field :reserved, inclusion: 'O', contents: 'C             ', position: 17..29
      nacha_field :amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :dfi_account_number, inclusion: 'M', contents: 'Numeric', position: 40..74
      nacha_field :reserved, inclusion: 'O', contents: 'C  ', position: 75..76
      nacha_field :gateway_operator_ofac_screening_indicator, inclusion: 'O', contents: 'Alphameric', position: 77..77
      nacha_field :secondary_ofac_screening_indicator, inclusion: 'O', contents: 'Alphameric', position: 78..78
      nacha_field :addenda_record_indicator, inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
