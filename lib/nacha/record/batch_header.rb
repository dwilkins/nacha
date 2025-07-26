# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/batch_header_record_type'

module Nacha
  module Record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as a Batch Header record with a constant value of '5'.
    # @!attribute [rw] service_class_code
    #   @return [Nacha::Numeric] Defines the type of entries in the batch, such as credits, debits, or mixed.
    # @!attribute [rw] company_name
    #   @return [String] The name of the company originating the entries in the batch.
    # @!attribute [rw] company_discretionary_data
    #   @return [String] Optional data field for the Originator's use.
    # @!attribute [rw] company_identification
    #   @return [String] A unique identifier for the company, typically a tax ID or a DDA number.
    # @!attribute [rw] standard_entry_class_code
    #   @return [String] A three-letter code (e.g., PPD, CCD) that identifies the payment type.
    # @!attribute [rw] company_entry_description
    #   @return [String] A description of the purpose of the entries in the batch.
    # @!attribute [rw] company_descriptive_date
    #   @return [String] A date chosen by the company to describe the entries, such as a payroll date.
    # @!attribute [rw] effective_entry_date
    #   @return [String] The date on which the entries are intended to be settled.
    # @!attribute [rw] settlement_date_julian
    #   @return [Nacha::Numeric] A Julian date used by the ACH Operator for settlement, not for use by the Originator.
    # @!attribute [rw] originator_status_code
    #   @return [String] A code indicating the status of the originator, typically '1' for a financial institution.
    # @!attribute [rw] originating_dfi_identification
    #   @return [String] The 8-digit routing number of the financial institution originating the batch.
    # @!attribute [rw] batch_number
    #   @return [Nacha::Numeric] A number assigned by the Originator to uniquely identify the batch.
    class BatchHeader < Nacha::Record::Base
      include BatchHeaderRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C5', position: 1..1
      nacha_field :service_class_code, inclusion: 'M', contents: 'Numeric', position: 2..4
      nacha_field :company_name, inclusion: 'M', contents: 'Alphameric', position: 5..20
      nacha_field :company_discretionary_data,
        inclusion: 'O', contents: 'Alphameric', position: 21..40
      nacha_field :company_identification,
        inclusion: 'M', contents: 'Alphameric', position: 41..50
      nacha_field :standard_entry_class_code,
        inclusion: 'M', contents: 'Alphameric', position: 51..53
      nacha_field :company_entry_description,
        inclusion: 'M', contents: 'Alphameric', position: 54..63
      nacha_field :company_descriptive_date,
        inclusion: 'O', contents: 'Alphameric', position: 64..69
      nacha_field :effective_entry_date,
        inclusion: 'R', contents: 'YYMMDD', position: 70..75
      nacha_field :settlement_date_julian,
        inclusion: 'O', contents: 'Numeric', position: 76..78
      nacha_field :originator_status_code,
        inclusion: 'M', contents: 'Alphameric', position: 79..79
      nacha_field :originating_dfi_identification,
        inclusion: 'M', contents: 'TTTTAAAA', position: 80..87
      nacha_field :batch_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
