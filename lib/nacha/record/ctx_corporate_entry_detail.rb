# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base.rb'
require 'nacha/record/detail_record_type.rb'

module Nacha
  module Record
    class CtxCorporateEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :dfi_account_number, inclusion: 'R', contents: 'Alphameric', position: 13..29
      nacha_field :total_amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :identification_number, inclusion: 'O', contents: 'Alphameric', position: 40..54
      nacha_field :number_of_addenda_records, inclusion: 'M', contents: 'Alphameric', position: 55..58
      nacha_field :receiving_company_name, inclusion: 'R', contents: 'Alphameric', position: 59..74
      nacha_field :reserved, inclusion: 'M', contents: 'Alphameric', position: 75..76
      nacha_field :discretionary_data, inclusion: 'O', contents: 'Alphameric', position: 77..78
      nacha_field :addenda_record_indicator, inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
