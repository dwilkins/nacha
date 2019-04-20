require 'nacha/record/base.rb'
require 'nacha/record/file_header_record_type.rb'

module Nacha
  module Record
    class FileHeader2 < Nacha::Record::Base
      include FileHeaderRecordType
      RECORD_DEFINITION = {
        record_type_code: { inclusion: 'M',  contents: 'C1',  position: 1..1 },
        priority_code: { inclusion: 'R', contents: 'Numeric', position: 2..3 },
        immediate_destination: { inclusion: 'M', contents: 'bTTTTAAAAC', position: 4..13 },
        immediate_origin: { inclusion: 'M', contents: 'bTTTTAAAAC', position: 14..23 },
        file_creation_date: { inclusion: 'M', contents: 'YYMMDD', position: 24..29 },
        file_creation_time: { inclusion: 'M', contents: 'HHMM', position: 30..33 },
        file_id_modifier: { inclusion: 'M', contents: 'A-Z0-9', position: 34..34 },
        record_size: { inclusion: 'M', contents: 'C094', position: 35..37 },
        blocking_factor: { inclusion: 'M', contents: 'C10', position: 38..39 },
        format_code: { inclusion: 'M', contents: 'C1', position: 40..40 },
        immediate_destination_name: { inclusion: 'M', contents: 'Alphameric', position: 41..63 },
        immediate_origin_name: { inclusion: 'M', contents: 'Alphameric', position: 64..86 },
        reference_code: { inclusion: 'M', contents: 'Alphameric',  position: 87..94 }
      }
    end
  end
end
