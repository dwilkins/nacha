# coding: utf-8
require 'nacha/record/base.rb'
require 'nacha/record/file_control_record_type.rb'

module Nacha
  module Record
    class AdvFileControl < Nacha::Record::Base
      nacha_field :record_type_code, inclusion: 'M', contents: 'C9', position: 1..1
      nacha_field :batch_count, inclusion: 'M', contents: 'Numeric', position: 2..7
      nacha_field :block_count, inclusion: 'M', contents: 'Numeric', position: 8..13
      nacha_field :entry_addenda_count, inclusion: 'M', contents: 'Numeric', position: 14..21
      nacha_field :entry_hash, inclusion: 'M', contents: 'Numeric', position: 22..31
      nacha_field :total_debit_entry_dollar_amount_in_file, inclusion: 'M', contents: '$$$$$$$$$$¢¢', position: 32..51
      nacha_field :total_credit_entry_dollar_amount_in_file, inclusion: 'M', contents: '$$$$$$$$$$¢¢', position: 52..71
      nacha_field :reserved, inclusion: 'M', contents: 'C', position: 72..94


      def initialize
        create_fields_from_definition
      end
    end

  end
end
