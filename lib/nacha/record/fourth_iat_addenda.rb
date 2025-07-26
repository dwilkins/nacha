# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents a fourth IAT addenda record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Specifies this is the fourth in a series of IAT addenda records with code '13'.
    # @!attribute [rw] originating_dfi_name
    #   @return [String] The name of the financial institution that originated the transaction.
    # @!attribute [rw] originating_dfi_identification_number_qualifier
    #   @return [String] A code that specifies the format of the originating DFI's identification number.
    # @!attribute [rw] originating_dfi_identification
    #   @return [String] The identification number of the originating financial institution.
    # @!attribute [rw] originating_dfi_branch_country_code
    #   @return [String] The ISO country code of the country where the originating DFI branch is located.
    # @!attribute [rw] reserved
    #   @return [String] A reserved field for future use.
    # @!attribute [rw] entry_detail_sequence_number
    #   @return [Nacha::Numeric] The sequence number of the IAT Entry Detail record this addenda is associated with.
    class FourthIatAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C13', position: 2..3
      nacha_field :originating_dfi_name, inclusion: 'M', contents: 'Alphameric', position: 4..38
      nacha_field :originating_dfi_identification_number_qualifier, inclusion: 'M', contents: 'Alphameric',
        position: 39..40
      nacha_field :originating_dfi_identification, inclusion: 'M', contents: 'Alphameric', position: 41..74
      nacha_field :originating_dfi_branch_country_code, inclusion: 'M', contents: 'Alphameric',
        position: 75..77
      nacha_field :reserved, inclusion: 'M', contents: 'C          ', position: 78..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
