# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents a first IAT addenda record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Specifies this is the first in a series of IAT addenda records with code '10'.
    # @!attribute [rw] transaction_type_code
    #   @return [String] A code that further specifies the type of IAT transaction (e.g., business, consumer).
    # @!attribute [rw] foreign_payment_amount
    #   @return [String] The amount of the payment in the foreign currency.
    # @!attribute [rw] foreign_trace_number
    #   @return [String] A trace number assigned by a foreign payment system.
    # @!attribute [rw] receiving_company_name
    #   @return [String] The name of the company that is the ultimate recipient of the funds.
    # @!attribute [rw] reserved
    #   @return [String] A reserved field for future use.
    # @!attribute [rw] entry_detail_sequence_number
    #   @return [Nacha::Numeric] The sequence number of the IAT Entry Detail record this addenda is associated with.
    class FirstIatAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C10', position: 2..3
      nacha_field :transaction_type_code, inclusion: 'R', contents: 'Alphameric', position: 4..6
      nacha_field :foreign_payment_amount, inclusion: 'R', contents: 'Alphameric', position: 7..24
      nacha_field :foreign_trace_number, inclusion: 'O', contents: 'Alphameric', position: 25..46
      nacha_field :receiving_company_name, inclusion: 'M', contents: 'Alphameric', position: 47..81
      nacha_field :reserved, inclusion: 'M', contents: 'C      ', position: 82..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
