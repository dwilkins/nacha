# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents a sixth IAT addenda record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Specifies this is the sixth in a series of IAT addenda records with code '15'.
    # @!attribute [rw] receiver_identification_number
    #   @return [String] An identification number for the receiver of the transaction.
    # @!attribute [rw] receiver_street_address
    #   @return [String] The street address of the receiver.
    # @!attribute [rw] reserved
    #   @return [String] A reserved field for future use.
    # @!attribute [rw] entry_detail_sequence_number
    #   @return [Nacha::Numeric] The sequence number of the IAT Entry Detail record this addenda is associated with.
    class SixthIatAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C15', position: 2..3
      nacha_field :receiver_identification_number, inclusion: 'O', contents: 'Alphameric', position: 4..18
      nacha_field :receiver_street_address, inclusion: 'M', contents: 'Alphameric', position: 19..53
      nacha_field :reserved, inclusion: 'M', contents: 'C                                  ',
        position: 54..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
