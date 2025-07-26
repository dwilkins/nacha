# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/detail_record_type'

module Nacha
  module Record
    # @!attribute [r] record_type_code
    #   @return [String]
    # @!attribute [r] transaction_code
    #   @return [Nacha::Numeric]
    # @!attribute [r] receiving_dfi_identification
    #   @return [String]
    # @!attribute [r] dfi_account_number
    #   @return [String]
    # @!attribute [r] amount
    #   @return [Nacha::Numeric]
    # @!attribute [r] advice_routing_number
    #   @return [Nacha::Numeric]
    # @!attribute [r] file_identification
    #   @return [String]
    # @!attribute [r] ach_operator_data
    #   @return [String]
    # @!attribute [r] individual_name
    #   @return [String]
    # @!attribute [r] discretionary_data
    #   @return [String]
    # @!attribute [r] addenda_record_indicator
    #   @return [Nacha::Numeric]
    # @!attribute [r] routing_number_of_ach_operator
    #   @return [String]
    # @!attribute [r] julian_date_created
    #   @return [Nacha::Numeric]
    # @!attribute [r] sequence_number
    #   @return [Nacha::Numeric]
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
