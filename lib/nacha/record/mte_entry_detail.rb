# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/detail_record_type'

module Nacha
  module Record
    # Represents a Machine Transfer Entry (MTE) detail record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an MTE Entry Detail record with a constant value of '6'.
    # @!attribute [rw] transaction_code
    #   @return [Nacha::Numeric] Defines the type of account and transaction.
    # @!attribute [rw] receiving_dfi_identification
    #   @return [Nacha::AbaNumber] The routing number of the financial institution receiving the funds.
    # @!attribute [rw] dfi_account_number
    #   @return [String] The account number being credited or debited.
    # @!attribute [rw] amount
    #   @return [Nacha::Numeric] The amount of the transaction.
    # @!attribute [rw] individual_name
    #   @return [String] The name of the individual cardholder.
    # @!attribute [rw] individual_identification_number
    #   @return [String] The cardholder's account number or other identifier.
    # @!attribute [rw] discretionary_data
    #   @return [String] An optional field for the Originator's use.
    # @!attribute [rw] addenda_record_indicator
    #   @return [Nacha::Numeric] Indicates if an addenda record with terminal information is present.
    # @!attribute [rw] trace_number
    #   @return [Nacha::Numeric] A unique number assigned by the ODFI for tracing the entry.
    class MteEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :dfi_account_number, inclusion: 'R', contents: 'Alphameric', position: 13..29
      nacha_field :amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :individual_name, inclusion: 'M', contents: 'Alphameric', position: 40..54
      nacha_field :individual_identification_number, inclusion: 'M', contents: 'Alphameric',
        position: 55..76
      nacha_field :discretionary_data, inclusion: 'O', contents: 'Alphameric', position: 77..78
      nacha_field :addenda_record_indicator, inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
