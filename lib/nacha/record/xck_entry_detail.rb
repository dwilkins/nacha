# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/detail_record_type'

module Nacha
  module Record
    # Represents a Destroyed Check Entry (XCK) detail record.
    class XckEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :dfi_account_number, inclusion: 'R', contents: 'Alphameric', position: 13..29
      nacha_field :amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :check_serial_number, inclusion: 'O', contents: 'Alphameric', position: 40..54
      nacha_field :process_control_field, inclusion: 'M', contents: 'Alphameric', position: 55..60
      nacha_field :item_research_number, inclusion: 'R', contents: 'Alphameric', position: 61..76
      nacha_field :discretionary_data, inclusion: 'O', contents: 'Alphameric', position: 77..78
      nacha_field :addenda_record_indicator, inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
