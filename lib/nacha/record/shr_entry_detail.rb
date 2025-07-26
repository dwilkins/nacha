# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/detail_record_type'

module Nacha
  module Record
    # Represents a Shared Network Entry (SHR) detail record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an SHR Entry Detail record with a constant value of '6'.
    # @!attribute [rw] transaction_code
    #   @return [Nacha::Numeric] Defines the type of account and transaction.
    # @!attribute [rw] receiving_dfi_identification
    #   @return [Nacha::AbaNumber] The routing number of the financial institution receiving the entry.
    # @!attribute [rw] dfi_account_number
    #   @return [String] The account number being credited or debited.
    # @!attribute [rw] amount
    #   @return [Nacha::Numeric] The amount of the transaction.
    # @!attribute [rw] card_expiration_date
    #   @return [String] The expiration date of the card used in the transaction.
    # @!attribute [rw] document_reference_number
    #   @return [String] A reference number for the transaction document.
    # @!attribute [rw] individual_card_account_number
    #   @return [String] The account number of the card used in the transaction.
    # @!attribute [rw] card_transaction_type
    #   @return [String] A code identifying the type of card transaction.
    # @!attribute [rw] addenda_record_indicator
    #   @return [Nacha::Numeric] Indicates if an addenda record with terminal information is present.
    # @!attribute [rw] trace_number
    #   @return [Nacha::Numeric] A unique number assigned by the ODFI to trace the entry.
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
