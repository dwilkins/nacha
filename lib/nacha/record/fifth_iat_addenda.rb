# frozen_string_literal: true

require 'nacha/record/base.rb'
require 'nacha/record/addenda_record_type.rb'
module Nacha
  module Record
    class FifthIatAddenda < Nacha::Record::Base
      include AddendaRecordType
      nacha_field :record_type_code, inclusion: 'M', contents: 'C7', position: 1..1
      nacha_field :addenda_type_code, inclusion: 'M', contents: 'C14', position: 2..3
      nacha_field :receiving_dfi_name, inclusion: 'M', contents: 'Alphameric', position: 4..38
      nacha_field :receiving_dfi_identification_number_qualifier, inclusion: 'M', contents: 'Alphameric', position: 39..40
      nacha_field :receiving_dfi_identification, inclusion: 'M', contents: 'Alphameric', position: 41..74
      nacha_field :receiving_dfi_branch_country_code, inclusion: 'M', contents: 'Alphameric', position: 75..77
      nacha_field :reserved, inclusion: 'M', contents: 'C          ', position: 78..87
      nacha_field :entry_detail_sequence_number, inclusion: 'M', contents: 'Numeric', position: 88..94
    end
  end
end
