# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/detail_record_type'

module Nacha
  module Record
    # Represents an IAT entry detail record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an IAT Entry Detail record with a constant value of '6'.
    # @!attribute [rw] transaction_code
    #   @return [Nacha::Numeric] Specifies the type of account and transaction (e.g., debit to a checking account).
    # @!attribute [rw] receiving_dfi_identification
    #   @return [Nacha::AbaNumber] The routing number of the U.S. financial institution that will receive the entry.
    # @!attribute [rw] number_of_addenda_records
    #   @return [String] The number of addenda records that follow this entry detail record.
    # @!attribute [rw] reserved1
    #   @return [String] A reserved field for future use.
    # @!attribute [rw] amount
    #   @return [Nacha::Numeric] The amount of the transaction in U.S. dollars.
    # @!attribute [rw] dfi_account_number
    #   @return [Nacha::Numeric] The account number of the receiver at the foreign financial institution.
    # @!attribute [rw] reserved2
    #   @return [String] A reserved field for future use.
    # @!attribute [rw] gateway_operator_ofac_screening_indicator
    #   @return [String] Indicates whether the Gateway Operator has screened the entry against the OFAC list.
    # @!attribute [rw] secondary_ofac_screening_indicator
    #   @return [String] Indicates whether a secondary screening has been performed.
    # @!attribute [rw] addenda_record_indicator
    #   @return [Nacha::Numeric] Indicates that one or more addenda records are present.
    # @!attribute [rw] trace_number
    #   @return [Nacha::Numeric] A unique number assigned by the ODFI to trace the entry.
    class IatEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :number_of_addenda_records, inclusion: 'M', contents: 'Alphameric', position: 13..16
      nacha_field :reserved1, inclusion: 'O', contents: 'C             ', position: 17..29
      nacha_field :amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :dfi_account_number, inclusion: 'M', contents: 'Numeric', position: 40..74
      nacha_field :reserved2, inclusion: 'O', contents: 'C  ', position: 75..76
      nacha_field :gateway_operator_ofac_screening_indicator, inclusion: 'O', contents: 'Alphameric',
        position: 77..77
      nacha_field :secondary_ofac_screening_indicator, inclusion: 'O', contents: 'Alphameric',
        position: 78..78
      nacha_field :addenda_record_indicator, inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
