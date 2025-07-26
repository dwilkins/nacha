# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/batch_control_record_type'

module Nacha
  module Record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as a Batch Control record with a constant value of '8'.
    # @!attribute [rw] service_class_code
    #   @return [Nacha::Numeric] Specifies the type of entries in the batch (e.g., credits, debits, or mixed).
    # @!attribute [rw] entry_addenda_count
    #   @return [Nacha::Numeric] The total count of entry detail and addenda records within the batch.
    # @!attribute [rw] entry_hash
    #   @return [Nacha::Numeric] A hash total of the routing numbers of all entry detail records in the batch for validation.
    # @!attribute [rw] total_debit_entry_dollar_amount
    #   @return [Nacha::Numeric] The total dollar amount of all debit entries in the batch.
    # @!attribute [rw] total_credit_entry_dollar_amount
    #   @return [Nacha::Numeric] The total dollar amount of all credit entries in the batch.
    # @!attribute [rw] company_identification
    #   @return [String] The identifier for the company that originated the entries in the batch.
    # @!attribute [rw] message_authentication_code
    #   @return [String] A code used to authenticate the batch, if required by the ODFI.
    # @!attribute [rw] reserved
    #   @return [String] A reserved field for future use.
    # @!attribute [rw] originating_dfi_identification
    #   @return [String] The 8-digit routing number of the financial institution originating the batch.
    # @!attribute [rw] batch_number
    #   @return [Nacha::Numeric] A number assigned by the ODFI to uniquely identify the batch.
    class BatchControl < Nacha::Record::Base
      include BatchControlRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C8', position: 1..1
      nacha_field :service_class_code, inclusion: 'M', contents: 'Numeric', position: 2..4
      nacha_field :entry_addenda_count, inclusion: 'M', contents: 'Numeric', position: 5..10
      nacha_field :entry_hash, inclusion: 'M', contents: 'Numeric', position: 11..20
      nacha_field :total_debit_entry_dollar_amount,
        inclusion: 'M', contents: '$$$$$$$$$$¢¢', position: 21..32
      nacha_field :total_credit_entry_dollar_amount,
        inclusion: 'M', contents: '$$$$$$$$$$¢¢', position: 33..44
      nacha_field :company_identification,
        inclusion: 'R', contents: 'Alphameric', position: 45..54
      nacha_field :message_authentication_code,
        inclusion: 'O', contents: 'Alphameric', position: 55..73
      nacha_field :reserved, inclusion: 'O', contents: 'C      ', position: 74..79
      nacha_field :originating_dfi_identification,
        inclusion: 'M', contents: 'TTTTAAAA', position: 80..87
      nacha_field :batch_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
