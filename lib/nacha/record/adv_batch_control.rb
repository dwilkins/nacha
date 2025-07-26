# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/batch_control_record_type'

module Nacha
  module Record
    # The AdvBatchControl record is used to control the batch of adv entry detail records.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an ADV Batch Control record with a constant value of '8'.
    # @!attribute [rw] service_class_code
    #   @return [Nacha::Numeric] Indicates the type of entries in the batch, such as automated accounting advices.
    # @!attribute [rw] entry_addenda_count
    #   @return [Nacha::Numeric] A count of all ADV Entry Detail records plus all Addenda records in the batch.
    # @!attribute [rw] entry_hash
    #   @return [Nacha::Numeric] A hash total of the routing numbers of all ADV Entry Detail records in the batch.
    # @!attribute [rw] total_debit_entry_dollar_amount
    #   @return [Nacha::Numeric] The total dollar amount of all debit entries in the batch, which is zero for ADV files.
    # @!attribute [rw] total_credit_entry_dollar_amount
    #   @return [Nacha::Numeric] The total dollar amount of all credit entries in the batch.
    # @!attribute [rw] ach_operator_data
    #   @return [String] Data that an ACH Operator may use to provide additional information about the batch.
    # @!attribute [rw] originating_dfi_identification
    #   @return [String] The 8-digit routing number of the ACH Operator that created the batch.
    # @!attribute [rw] batch_number
    #   @return [Nacha::Numeric] A number assigned by the ACH Operator to uniquely identify the batch.
    class AdvBatchControl < Nacha::Record::Base
      include BatchControlRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C8', position: 1..1
      nacha_field :service_class_code, inclusion: 'M', contents: 'Numeric', position: 2..4
      nacha_field :entry_addenda_count, inclusion: 'M', contents: 'Numeric', position: 5..10
      nacha_field :entry_hash, inclusion: 'M', contents: 'Numeric', position: 11..20
      nacha_field :total_debit_entry_dollar_amount,
        inclusion: 'M', contents: '$$$$$$$$$$$$$$$$$$¢¢', position: 21..40
      nacha_field :total_credit_entry_dollar_amount,
        inclusion: 'M', contents: '$$$$$$$$$$$$$$$$$$¢¢', position: 41..60
      nacha_field :ach_operator_data,
        inclusion: 'O', contents: 'Alphameric', position: 61..79
      nacha_field :originating_dfi_identification,
        inclusion: 'M', contents: 'TTTAAAA', position: 80..87
      nacha_field :batch_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
