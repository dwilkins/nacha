# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents a Prearranged Payment and Deposit (PPD) addenda record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Specifies the type of addenda, '05' for PPD payment-related information.
    # @!attribute [rw] payment_related_information
    #   @return [String] Contains additional information about the payment, such as a reference number.
    # @!attribute [rw] addenda_sequence_number
    #   @return [Nacha::Numeric] The sequence number for this addenda record.
    # @!attribute [rw] entry_detail_sequence_number
    #   @return [Nacha::Numeric] The sequence number of the associated PPD Entry Detail record.
    class PpdAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C05', position: 2..3
      nacha_field :payment_related_information, inclusion: 'O', contents: 'Alphameric', position: 4..83
      nacha_field :addenda_sequence_number, inclusion: 'M', contents: 'Numeric', position: 84..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
