# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'
module Nacha
  module Record
    # Represents a fifth IAT addenda record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Specifies this is the fifth in a series of IAT addenda records with code '14'.
    # @!attribute [rw] receiving_dfi_name
    #   @return [String] The name of the financial institution that will receive the transaction.
    # @!attribute [rw] receiving_dfi_identification_number_qualifier
    #   @return [String] A code that specifies the format of the receiving DFI's identification number.
    # @!attribute [rw] receiving_dfi_identification
    #   @return [String] The identification number of the receiving financial institution.
    # @!attribute [rw] receiving_dfi_branch_country_code
    #   @return [String] The ISO country code of the country where the receiving DFI branch is located.
    # @!attribute [rw] reserved
    #   @return [String] A reserved field for future use.
    # @!attribute [rw] entry_detail_sequence_number
    #   @return [Nacha::Numeric] The sequence number of the IAT Entry Detail record this addenda is associated with.
    class FifthIatAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C14', position: 2..3
      nacha_field :receiving_dfi_name, inclusion: 'M', contents: 'Alphameric', position: 4..38
      nacha_field :receiving_dfi_identification_number_qualifier, inclusion: 'M', contents: 'Alphameric',
        position: 39..40
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'Alphameric', position: 41..74
      nacha_field :receiving_dfi_branch_country_code, inclusion: 'M', contents: 'Alphameric',
        position: 75..77
      nacha_field :reserved, inclusion: 'M', contents: 'C          ', position: 78..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
