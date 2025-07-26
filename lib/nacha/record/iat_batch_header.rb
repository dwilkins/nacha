# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/batch_header_record_type'

module Nacha
  module Record
    # Represents an IAT batch header record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as a Batch Header record with a constant value of '5'.
    # @!attribute [rw] service_class_code
    #   @return [Nacha::Numeric] Defines the type of entries in the batch, such as credits or debits.
    # @!attribute [rw] iat_indicator
    #   @return [String] Provides supplemental information about the IAT entry.
    # @!attribute [rw] foreign_exchange_indicator
    #   @return [String] Indicates the method used to determine the foreign exchange rate.
    # @!attribute [rw] foreign_exchange_reference_indicator
    #   @return [Nacha::Numeric] A code indicating the content of the Foreign Exchange Reference field.
    # @!attribute [rw] foreign_exchange_reference
    #   @return [String] A reference related to the foreign exchange conversion.
    # @!attribute [rw] iso_destination_country_code
    #   @return [String] The two-character ISO code for the country of the receiver's financial institution.
    # @!attribute [rw] originator_identification
    #   @return [String] The identifier for the originator of the transaction.
    # @!attribute [rw] standard_entry_class_code
    #   @return [String] The Standard Entry Class code, which is 'IAT' for these batches.
    # @!attribute [rw] company_entry_description
    #   @return [String] A description of the purpose of the entries in the batch.
    # @!attribute [rw] iso_originating_currency_code
    #   @return [String] The three-character ISO currency code of the originating country.
    # @!attribute [rw] iso_destination_currency_code
    #   @return [String] The three-character ISO currency code of the destination country.
    # @!attribute [rw] effective_entry_date
    #   @return [String] The date on which the entries are intended to be settled.
    # @!attribute [rw] settlement_date_julian
    #   @return [Nacha::Numeric] A Julian date used by the ACH Operator for settlement.
    # @!attribute [rw] originator_status_code
    #   @return [String] A code indicating the status of the originator.
    # @!attribute [rw] originating_dfi_identification
    #   @return [String] The 8-digit routing number of the financial institution originating the batch.
    # @!attribute [rw] batch_number
    #   @return [Nacha::Numeric] A number assigned by the Originator to uniquely identify the batch.
    class IatBatchHeader < Nacha::Record::Base
      include BatchHeaderRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C5', position: 1..1
      nacha_field :service_class_code, inclusion: 'M', contents: 'Numeric', position: 2..4
      nacha_field :iat_indicator, inclusion: 'O', contents: 'Alphameric', position: 5..20
      nacha_field :foreign_exchange_indicator, inclusion: 'M', contents: 'Alphameric', position: 21..22
      nacha_field :foreign_exchange_reference_indicator, inclusion: 'R', contents: 'Numeric',
        position: 23..23
      nacha_field :foreign_exchange_reference, inclusion: 'R', contents: 'Alphameric', position: 24..38
      nacha_field :iso_destination_country_code, inclusion: 'M', contents: 'Alphameric', position: 39..40
      nacha_field :originator_identification, inclusion: 'M', contents: 'Alphameric', position: 41..50
      nacha_field :standard_entry_class_code, inclusion: 'M', contents: 'Alphameric', position: 51..53
      nacha_field :company_entry_description, inclusion: 'M', contents: 'Alphameric', position: 54..63
      nacha_field :iso_originating_currency_code, inclusion: 'M', contents: 'Alphameric', position: 64..66
      nacha_field :iso_destination_currency_code, inclusion: 'M', contents: 'Alphameric', position: 67..69
      nacha_field :effective_entry_date, inclusion: 'R', contents: 'YYMMDD', position: 70..75
      nacha_field :settlement_date_julian, inclusion: 'M', contents: 'Numeric', position: 76..78
      nacha_field :originator_status_code, inclusion: 'M', contents: 'Alphameric', position: 79..79
      nacha_field :originating_dfi_identification, inclusion: 'M', contents: 'TTTTAAAA', position: 80..87
      nacha_field :batch_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
