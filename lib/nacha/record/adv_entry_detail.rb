# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/detail_record_type'

module Nacha
  module Record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an ADV Entry Detail record with a constant value of '6'.
    # @!attribute [rw] transaction_code
    #   @return [Nacha::Numeric] Identifies the type of transaction, such as a credit or debit.
    # @!attribute [rw] receiving_dfi_identification
    #   @return [Nacha::AbaNumber] The routing number of the financial institution that is to receive the credit or debit entry.
    # @!attribute [rw] dfi_account_number
    #   @return [String] The account number at the receiving financial institution to be credited or debited.
    # @!attribute [rw] amount
    #   @return [Nacha::Numeric] The total dollar amount of the entry.
    # @!attribute [rw] advice_routing_number
    #   @return [Nacha::Numeric] The routing number of the financial institution responsible for the advice of entry.
    # @!attribute [rw] file_identification
    #   @return [String] An optional field used by an ACH Operator to uniquely identify the file.
    # @!attribute [rw] ach_operator_data
    #   @return [String] Optional data used by an ACH Operator.
    # @!attribute [rw] individual_name
    #   @return [String] The name of the Receiver from the original Entry Detail Record.
    # @!attribute [rw] discretionary_data
    #   @return [String] Optional data field which can be used by the ODFI or Originator for their own purposes.
    # @!attribute [rw] addenda_record_indicator
    #   @return [Nacha::Numeric] A code indicating whether an addenda record follows, '1' for yes and '0' for no.
    # @!attribute [rw] routing_number_of_ach_operator
    #   @return [String] The routing number of the ACH Operator that created the ADV entry.
    # @!attribute [rw] julian_date_created
    #   @return [Nacha::Numeric] The Julian date on which the ADV entry was created.
    # @!attribute [rw] sequence_number
    #   @return [Nacha::Numeric] A number assigned by the ACH Operator to uniquely identify the entry within the file.
    class AdvEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :dfi_account_number, inclusion: 'R', contents: 'Alphameric', position: 13..29
      nacha_field :amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :advice_routing_number, inclusion: 'M', contents: 'Numeric', position: 40..48
      nacha_field :file_identification, inclusion: 'O', contents: 'Alphameric', position: 49..53
      nacha_field :ach_operator_data, inclusion: 'O', contents: 'Alphameric', position: 54..54
      nacha_field :individual_name, inclusion: 'R', contents: 'Alphameric', position: 55..76
      nacha_field :discretionary_data, inclusion: 'O', contents: 'Alphameric', position: 77..78
      nacha_field :addenda_record_indicator, inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :routing_number_of_ach_operator, inclusion: 'M', contents: 'TTTTAAAA', position: 80..87
      nacha_field :julian_date_created, inclusion: 'M', contents: 'Numeric', position: 88..90
      nacha_field :sequence_number, inclusion: 'M', contents: 'Numeric', position: 91..94
    end
  end
end
