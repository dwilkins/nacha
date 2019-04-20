require 'nacha/record/base.rb'
require 'nacha/record/addenda_record_type.rb'
module Nacha
  module Record
    class FifthIatAddenda < Nacha::Record::Base
      include AddendaRecordType
      RECORD_DEFINITION = {
        record_type_code:
          {inclusion: "M", contents: "C7", position: 1..1},
        addenda_type_code:
          {inclusion: "M", contents: "C14", position: 2..3},
        receiving_dfi_name:
          {inclusion: "M", contents: "Alphameric", position: 4..38},
        receiving_dfi_identification_number_qualifier:
          {inclusion: "M", contents: "Alphameric", position: 39..40},
        receiving_dfi_identification:
          {inclusion: "M", contents: "Alphameric", position: 41..74},
        receiving_dfi_branch_country_code:
          {inclusion: "M", contents: "Alphameric", position: 75..77},
        reserved:
          {inclusion: "M", contents: "C          ", position: 78..87},
        entry_detail_sequence_number:
          {inclusion: "M", contents: "Numeric", position: 88..94}
      }
    end
  end
end
