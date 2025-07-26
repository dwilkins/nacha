# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents an IAT Foreign Correspondent Bank Information addenda record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Specifies this is a foreign correspondent bank information addenda record with code '18'.
    # @!attribute [rw] foreign_correspondent_bank_name
    #   @return [String] The name of the foreign correspondent bank.
    # @!attribute [rw] foreign_correspondent_bank_identification_number_qualifier
    #   @return [String] A code qualifying the identification number of the foreign correspondent bank.
    # @!attribute [rw] foreign_correspondent_bank_identification_number
    #   @return [String] The identification number of the foreign correspondent bank.
    # @!attribute [rw] foreign_correspondent_bank_branch_country_code
    #   @return [String] The ISO country code of the foreign correspondent bank's branch.
    # @!attribute [rw] reserved
    #   @return [String] A reserved field for future use.
    # @!attribute [rw] addenda_sequence_number
    #   @return [Nacha::Numeric] The sequence number for this addenda record within the entry.
    # @!attribute [rw] entry_detail_sequence_number
    #   @return [Nacha::Numeric] The sequence number of the IAT Entry Detail record this addenda is associated with.
    class IatForeignCoorespondentBankInformationAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C18', position: 2..3
      nacha_field :foreign_correspondent_bank_name, inclusion: 'M', contents: 'Alphameric', position: 4..38
      nacha_field :foreign_correspondent_bank_identification_number_qualifier, inclusion: 'M',
        contents: 'Alphameric', position: 39..40
      nacha_field :foreign_correspondent_bank_identification_number, inclusion: 'M',
        contents: 'Alphameric', position: 41..74
      nacha_field :foreign_correspondent_bank_branch_country_code, inclusion: 'M', contents: 'Alphameric',
        position: 75..77
      nacha_field :reserved, inclusion: 'M', contents: 'C      ', position: 78..83
      nacha_field :addenda_sequence_number, inclusion: 'M', contents: 'Numeric', position: 84..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
