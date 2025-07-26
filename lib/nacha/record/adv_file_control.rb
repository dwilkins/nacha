# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/file_control_record_type'

module Nacha
  module Record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an ADV File Control record with a constant value of '9'.
    # @!attribute [rw] batch_count
    #   @return [Nacha::Numeric] The total number of batch records in the file.
    # @!attribute [rw] block_count
    #   @return [Nacha::Numeric] The total number of blocks in the file, where a block is 10 lines.
    # @!attribute [rw] entry_addenda_count
    #   @return [Nacha::Numeric] The total number of entry detail and addenda records in the file.
    # @!attribute [rw] entry_hash
    #   @return [Nacha::Numeric] The sum of all Entry Hash fields from the Batch Control records in the file.
    # @!attribute [rw] total_debit_entry_dollar_amount_in_file
    #   @return [Nacha::Numeric] The total value of all debit entries in the file, which is zero for ADV files.
    # @!attribute [rw] total_credit_entry_dollar_amount_in_file
    #   @return [Nacha::Numeric] The total value of all credit entries in the file.
    # @!attribute [rw] reserved
    #   @return [String] A reserved field for future use.
    class AdvFileControl < Nacha::Record::Base
      include FileControlRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C9', position: 1..1
      nacha_field :batch_count, inclusion: 'M', contents: 'Numeric', position: 2..7
      nacha_field :block_count, inclusion: 'M', contents: 'Numeric', position: 8..13
      nacha_field :entry_addenda_count,
        inclusion: 'M', contents: 'Numeric', position: 14..21
      nacha_field :entry_hash, inclusion: 'M', contents: 'Numeric', position: 22..31
      nacha_field :total_debit_entry_dollar_amount_in_file,
        inclusion: 'M', contents: '$$$$$$$$$$¢¢', position: 32..51
      nacha_field :total_credit_entry_dollar_amount_in_file,
        inclusion: 'M', contents: '$$$$$$$$$$¢¢', position: 52..71
      nacha_field :reserved, inclusion: 'M', contents: 'C', position: 72..94
    end
  end
end
