# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents a Machine Transfer Entry (MTE) addenda record.
    class MteAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C02', position: 2..3
      nacha_field :transaction_description, inclusion: 'R', contents: 'Alphameric', position: 4..10
      nacha_field :network_identification_code, inclusion: 'O', contents: 'Alphameric', position: 11..13
      nacha_field :terminal_identification_code, inclusion: 'R', contents: 'Alphameric', position: 14..19
      nacha_field :transaction_serial_number, inclusion: 'R', contents: 'Alphameric', position: 20..25
      nacha_field :transaction_date, inclusion: 'R', contents: 'MMDD', position: 26..29
      nacha_field :transaction_time, inclusion: 'R', contents: 'HHMMSS', position: 30..35
      nacha_field :terminal_location, inclusion: 'R', contents: 'Alphameric', position: 36..62
      nacha_field :terminal_city, inclusion: 'R', contents: 'Alphameric', position: 63..77
      nacha_field :terminal_state, inclusion: 'R', contents: 'Alphameric', position: 78..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
