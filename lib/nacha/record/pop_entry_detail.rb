# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/detail_record_type'

module Nacha
  module Record
    # Represents a Point-of-Purchase (POP) entry detail record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as a POP Entry Detail record with a constant value of '6'.
    # @!attribute [rw] transaction_code
    #   @return [Nacha::Numeric] Defines the type of account and transaction (debit).
    # @!attribute [rw] receiving_dfi_identification
    #   @return [Nacha::AbaNumber] The routing number of the financial institution receiving the entry.
    # @!attribute [rw] dfi_account_number
    #   @return [String] The account number to be debited.
    # @!attribute [rw] amount
    #   @return [Nacha::Numeric] The amount of the transaction from the source check.
    # @!attribute [rw] check_serial_number
    #   @return [String] The serial number of the source check.
    # @!attribute [rw] terminal_city
    #   @return [String] The city where the point-of-purchase terminal is located.
    # @!attribute [rw] terminal_state
    #   @return [String] The state where the point-of-purchase terminal is located.
    # @!attribute [rw] individual_name
    #   @return [String] The name of the individual who wrote the check.
    # @!attribute [rw] discretionary_data
    #   @return [String] An optional field for the Originator's use.
    # @!attribute [rw] addenda_record_indicator
    #   @return [Nacha::Numeric] Indicates if an addenda record is present.
    # @!attribute [rw] trace_number
    #   @return [Nacha::Numeric] A unique number assigned by the ODFI to trace the entry.
    class PopEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :dfi_account_number, inclusion: 'R', contents: 'Alphameric', position: 13..29
      nacha_field :amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :check_serial_number, inclusion: 'M', contents: 'Alphameric', position: 40..48
      nacha_field :terminal_city, inclusion: 'M', contents: 'Alphameric', position: 49..52
      nacha_field :terminal_state, inclusion: 'R', contents: 'Alphameric', position: 53..54
      nacha_field :individual_name, inclusion: 'O', contents: 'Alphameric', position: 55..76
      nacha_field :discretionary_data, inclusion: 'O', contents: 'Alphameric', position: 77..78
      nacha_field :addenda_record_indicator, inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
