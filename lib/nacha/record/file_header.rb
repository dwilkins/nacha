# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/file_header_record_type'

module Nacha
  module Record
    # The FileHeader record is the first record in a
    # Nacha file and contains information about the file itself.
    class FileHeader < Nacha::Record::Base
      include FileHeaderRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C1', position: 1..1
      nacha_field :priority_code, inclusion: 'R', contents: 'Numeric', position: 2..3
      nacha_field :immediate_destination,
        inclusion: 'M', contents: 'bTTTTAAAAC', position: 4..13
      nacha_field :immediate_origin,
        inclusion: 'M', contents: 'bTTTTAAAAC', position: 14..23
      nacha_field :file_creation_date,  inclusion: 'M', contents: 'YYMMDD', position: 24..29
      nacha_field :file_creation_time,  inclusion: 'M', contents: 'HHMM', position: 30..33
      nacha_field :file_id_modifier, inclusion: 'M', contents: 'A-Z0-9', position: 34..34
      nacha_field :record_size, inclusion: 'M', contents: 'C094', position: 35..37
      nacha_field :blocking_factor, inclusion: 'M', contents: 'C10', position: 38..39
      nacha_field :format_code, inclusion: 'M', contents: 'C1', position: 40..40
      nacha_field :immediate_destination_name,
        inclusion: 'M', contents: 'Alphameric', position: 41..63
      nacha_field :immediate_origin_name,
        inclusion: 'M', contents: 'Alphameric', position: 64..86
      nacha_field :reference_code, inclusion: 'M', contents: 'Alphameric', position: 87..94
    end
  end
end
