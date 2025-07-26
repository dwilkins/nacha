# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents an Automated Enrollment Entry (ENR) addenda record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Indicates the type of addenda information, '05' for ENR.
    # @!attribute [rw] payment_related_information
    #   @return [String] Contains enrollment-related information provided by the Federal Government agency.
    # @!attribute [rw] addenda_sequence_number
    #   @return [Nacha::Numeric] The sequence number of this addenda record.
    # @!attribute [rw] entry_detail_sequence_number
    #   @return [Nacha::Numeric] The sequence number of the associated ENR Entry Detail record.
    class EnrAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C05', position: 2..3
      nacha_field :payment_related_information, inclusion: 'R', contents: 'Alphameric', position: 4..83
      nacha_field :addenda_sequence_number, inclusion: 'M', contents: 'Numeric', position: 84..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
