# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/detail_record_type'

module Nacha
  module Record
    # Represents a Death Notification Entry (DNE) detail record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as a DNE Entry Detail record with a constant value of '6'.
    # @!attribute [rw] transaction_code
    #   @return [Nacha::Numeric] Defines the transaction as a DNE.
    # @!attribute [rw] receiving_dfi_identification
    #   @return [Nacha::AbaNumber] The routing number of the financial institution that received the original payment.
    # @!attribute [rw] dfi_account_number
    #   @return [String] The account number of the deceased individual.
    # @!attribute [rw] amount
    #   @return [Nacha::Numeric] The amount of the entry, which is typically zero for a DNE.
    # @!attribute [rw] individual_identification_number
    #   @return [String] The Social Security Number of the deceased individual.
    # @!attribute [rw] individual_name
    #   @return [String] The name of the deceased individual.
    # @!attribute [rw] discretionary_data
    #   @return [String] Optional data field for the Originator's use.
    # @!attribute [rw] addenda_record_indicator
    #   @return [Nacha::Numeric] Indicates if an addenda record with further information is present.
    # @!attribute [rw] trace_number
    #   @return [Nacha::Numeric] A unique number assigned by the ODFI for tracing the entry.
    class DneEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :dfi_account_number, inclusion: 'M', contents: 'Alphameric', position: 13..29
      nacha_field :amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :individual_identification_number, inclusion: 'O', contents: 'Alphameric',
        position: 40..54
      nacha_field :individual_name, inclusion: 'R', contents: 'Alphameric', position: 55..76
      nacha_field :discretionary_data, inclusion: 'O', contents: 'Alphameric', position: 77..78
      nacha_field :addenda_record_indicator, inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
