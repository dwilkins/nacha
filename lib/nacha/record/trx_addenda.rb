# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents a Truncated Entry (TRX) addenda record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Specifies the type of addenda, '05' for TRX remittance information.
    # @!attribute [rw] payment_related_information
    #   @return [String] Contains remittance information, such as invoice numbers.
    # @!attribute [rw] addenda_sequence_number
    #   @return [Nacha::Numeric] The sequence number of this addenda record within the entry.
    # @!attribute [rw] entry_detail_sequence_number
    #   @return [Nacha::Numeric] The sequence number of the associated TRX Entry Detail record.
    class TrxAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C05', position: 2..3
      nacha_field :payment_related_information, inclusion: 'O', contents: 'Alphameric', position: 4..83
      nacha_field :addenda_sequence_number, inclusion: 'M', contents: 'Numeric', position: 84..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
