# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents a seventh IatAddenda addenda record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Specifies this is the seventh in a series of IAT addenda records with code '16'.
    # @!attribute [rw] receiver_city_state
    #   @return [String] The city and state/province of the receiver.
    # @!attribute [rw] receiver_country_postal
    #   @return [String] The country and postal code of the receiver.
    # @!attribute [rw] reserved
    #   @return [String] A reserved field for future use.
    # @!attribute [rw] entry_detail_sequence_number
    #   @return [Nacha::Numeric] The sequence number of the IAT Entry Detail record this addenda is associated with.
    class SeventhIatAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C16', position: 2..3
      nacha_field :receiver_city_state, inclusion: 'M', contents: 'Alphameric', position: 4..38
      nacha_field :receiver_country_postal, inclusion: 'M', contents: 'Alphameric', position: 39..73
      nacha_field :reserved, inclusion: 'M', contents: 'C              ', position: 74..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
