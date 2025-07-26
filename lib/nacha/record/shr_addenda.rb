# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/addenda_record_type'

module Nacha
  module Record
    # Represents a Shared Network Entry (SHR) addenda record.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an Addenda record with a constant value of '7'.
    # @!attribute [rw] addenda_type_code
    #   @return [String] Specifies the type of addenda, '02' for SHR terminal information.
    # @!attribute [rw] reference_information_1
    #   @return [String] First reference field for additional transaction details.
    # @!attribute [rw] reference_information_2
    #   @return [String] Second reference field for additional transaction details.
    # @!attribute [rw] terminal_identification_code
    #   @return [String] A unique code identifying the shared network terminal.
    # @!attribute [rw] transaction_serial_number
    #   @return [String] The serial number assigned to the transaction by the terminal.
    # @!attribute [rw] transaction_date
    #   @return [String] The date of the shared network transaction.
    # @!attribute [rw] authorization_code_or_card_expiration_date
    #   @return [String] The authorization code or card expiration date for the transaction.
    # @!attribute [rw] terminal_location
    #   @return [String] The physical location of the terminal.
    # @!attribute [rw] terminal_city
    #   @return [String] The city where the terminal is located.
    # @!attribute [rw] terminal_state
    #   @return [Nacha::Numeric] The state where the terminal is located.
    # @!attribute [rw] trace_number
    #   @return [Nacha::Numeric] The trace number of the associated SHR Entry Detail record.
    class ShrAddenda < Nacha::Record::Base
      include AddendaRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C02', position: 2..3
      nacha_field :reference_information_1, inclusion: 'O', contents: 'Alphameric', position: 4..10
      nacha_field :reference_information_2, inclusion: 'O', contents: 'Alphameric', position: 11..13
      nacha_field :terminal_identification_code, inclusion: 'R', contents: 'Alphameric', position: 14..19
      nacha_field :transaction_serial_number, inclusion: 'R', contents: 'Alphameric', position: 20..25
      nacha_field :transaction_date, inclusion: 'O', contents: 'Alphameric', position: 26..29
      nacha_field :authorization_code_or_card_expiration_date, inclusion: 'O', contents: 'Alphameric',
        position: 30..35
      nacha_field :terminal_location, inclusion: 'R', contents: 'Alphameric', position: 36..62
      nacha_field :terminal_city, inclusion: 'R', contents: 'Alphameric', position: 63..77
      nacha_field :terminal_state, inclusion: 'M', contents: 'Numeric', position: 78..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
