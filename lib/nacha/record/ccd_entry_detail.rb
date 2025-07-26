# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/detail_record_type'

module Nacha
  module Record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as a CCD Entry Detail record with a constant value of '6'.
    # @!attribute [rw] transaction_code
    #   @return [Nacha::Numeric] Defines the type of account and transaction (e.g., credit to a checking account).
    # @!attribute [rw] receiving_dfi_identification
    #   @return [Nacha::AbaNumber] The routing number of the financial institution that will receive the entry.
    # @!attribute [rw] dfi_account_number
    #   @return [String] The account number at the receiving institution to be credited or debited.
    # @!attribute [rw] amount
    #   @return [Nacha::Numeric] The transaction amount.
    # @!attribute [rw] identification_number
    #   @return [String] An identifier for the receiver of the entry.
    # @!attribute [rw] receiving_company_name
    #   @return [String] The name of the company receiving the payment.
    # @!attribute [rw] discretionary_data
    #   @return [String] Optional data field for use by the Originator.
    # @!attribute [rw] addenda_record_indicator
    #   @return [Nacha::Numeric] A flag indicating if an addenda record is included.
    # @!attribute [rw] trace_number
    #   @return [Nacha::Numeric] A unique number assigned by the ODFI to trace the transaction.
    class CcdEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :dfi_account_number, inclusion: 'R', contents: 'Alphameric', position: 13..29
      nacha_field :amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :identification_number, inclusion: 'O', contents: 'Alphameric', position: 40..54
      nacha_field :receiving_company_name, inclusion: 'R', contents: 'Alphameric', position: 55..76
      nacha_field :discretionary_data, inclusion: 'O', contents: 'Alphameric', position: 77..78
      nacha_field :addenda_record_indicator, inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
