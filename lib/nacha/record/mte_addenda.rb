# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents a Machine Transfer Entry (MTE) addenda record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Specifies the type of addenda, '02' for MTE terminal information.
    # @!attribute [rw] transaction_description
    #   @return [String] A description of the transaction.
    # @!attribute [rw] network_identification_code
    #   @return [String] Identifies the ATM network through which the transaction was processed.
    # @!attribute [rw] terminal_identification_code
    #   @return [String] A unique code identifying the ATM terminal.
    # @!attribute [rw] transaction_serial_number
    #   @return [String] The serial number assigned to the transaction by the terminal.
    # @!attribute [rw] transaction_date
    #   @return [String] The date of the transaction in MMDD format.
    # @!attribute [rw] transaction_time
    #   @return [String] The time of the transaction in HHMMSS format.
    # @!attribute [rw] terminal_location
    #   @return [String] The physical location of the terminal.
    # @!attribute [rw] terminal_city
    #   @return [String] The city where the terminal is located.
    # @!attribute [rw] terminal_state
    #   @return [String] The state where the terminal is located.
    # @!attribute [rw] trace_number
    #   @return [Nacha::Numeric] The trace number of the associated MTE Entry Detail record.
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
