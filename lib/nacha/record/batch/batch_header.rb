require 'nacha/record/base.rb'
require 'nacha/record/batch/batch_header_record_type.rb'

module Nacha
  module Record
    class BatchHeader < Nacha::Record::Base
      include BatchHeaderRecordType
      nacha_field :record_type_code, inclusion: 'M', contents: 'C5', position: 1..1
      nacha_field :service_class_code, inclusion: 'M', contents: 'Numeric', position: 2..4
      nacha_field :company_name, inclusion: 'M', contents: 'Alphameric', position: 5..20
      nacha_field :company_discretionary_data, inclusion: 'O', contents: 'Alphameric', position: 21..40
      nacha_field :company_identification, inclusion: 'M', contents: 'Alphameric', position: 41..50
      nacha_field :standard_entry_class_code, inclusion: 'M', contents: 'Alphameric', position: 51..53
      nacha_field :company_entry_description, inclusion: 'M', contents: 'Alphameric', position: 54..63
      nacha_field :company_descriptive_date, inclusion: 'O', contents: 'Alphameric', position: 64..69
      nacha_field :effective_entry_date, inclusion: 'R', contents: 'YYMMDD', position: 70..75
      nacha_field :settlement_date_julian, inclusion: 'M', contents: 'Numeric', position: 76..78
      nacha_field :originator_status_code, inclusion: 'M', contents: 'Alphameric', position: 79..79
      nacha_field :originating_dfi_identification, inclusion: 'M', contents: 'TTTTAAAA', position: 80..87
      nacha_field :batch_number,  inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
