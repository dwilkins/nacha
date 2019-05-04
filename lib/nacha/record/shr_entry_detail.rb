# coding: utf-8
require 'nacha/record/base.rb'
require 'nacha/record/detail_record_type.rb'

module Nacha
  module Record
    class ShrEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :dfi_account_number, inclusion: 'R', contents: 'Alphameric', position: 13..29
      nacha_field :amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :card_expiration_date, inclusion: 'O', contents: 'Alphameric', position: 40..43
      nacha_field :document_reference_number, inclusion: 'R', contents: 'Alphameric', position: 44..54
      nacha_field :individual_card_account_number, inclusion: 'R', contents: 'Alphameric', position: 55..76
      nacha_field :card_transaction_type, inclusion: 'M', contents: 'Alphameric', position: 77..78
      nacha_field :addenda_record_indicator, inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
