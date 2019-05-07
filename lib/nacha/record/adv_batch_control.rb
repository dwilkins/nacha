# coding: utf-8
require 'nacha/record/base.rb'
require 'nacha/record/batch_control_record_type.rb'

module Nacha
  module Record
    class AdvBatchControl < Nacha::Record::Base
    nacha_field :record_type_code, inclusion: 'M', contents: 'C8', position: 1..1
    nacha_field :service_class_code, inclusion: 'M', contents: 'Numeric', position: 2..4
    nacha_field :entry_addenda_count, inclusion: 'M', contents: 'Numeric', position: 5..10
    nacha_field :entry_hash, inclusion: 'M', contents: 'Numeric', position: 11..20
    nacha_field :total_debit_entry_dollar_amount, inclusion: 'M',    contents: '$$$$$$$$$$$$$$$$$$¢¢', position: 21..40
    nacha_field :total_credit_entry_dollar_amount, inclusion: 'M', contents: '$$$$$$$$$$$$$$$$$$¢¢', position: 41..60
    nacha_field :ach_operator_data, inclusion: 'O', contents: 'Alphameric', position: 61..79
    nacha_field :originating_dfi_identification, inclusion: 'M', contents: 'TTTAAAA', position: 80..87
    nacha_field :batch_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
