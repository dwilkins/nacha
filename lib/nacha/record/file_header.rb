# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/file_header_record_type'

module Nacha
  module Record
    # The FileHeader record is the first record in a
    # Nacha file and contains information about the file itself.
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as a File Header record with a constant value of '1'.
    # @!attribute [rw] priority_code
    #   @return [Nacha::Numeric] A code assigned by the ODFI to indicate the processing priority of the file.
    # @!attribute [rw] immediate_destination
    #   @return [Nacha::AbaNumber] The routing number of the ACH Operator or receiving point to which the file is sent.
    # @!attribute [rw] immediate_origin
    #   @return [Nacha::AbaNumber] The routing number of the ODFI or sending point that created the file.
    # @!attribute [rw] file_creation_date
    #   @return [String] The date the file was created, in YYMMDD format.
    # @!attribute [rw] file_creation_time
    #   @return [String] The time the file was created, in HHMM format.
    # @!attribute [rw] file_id_modifier
    #   @return [String] A character used to distinguish between multiple files created on the same day.
    # @!attribute [rw] record_size
    #   @return [String] The fixed number of characters per record, which is always '094'.
    # @!attribute [rw] blocking_factor
    #   @return [String] The number of records in a block, which is always '10'.
    # @!attribute [rw] format_code
    #   @return [String] Indicates the version of the Nacha file format, typically '1'.
    # @!attribute [rw] immediate_destination_name
    #   @return [String] The name of the ACH Operator or receiving point.
    # @!attribute [rw] immediate_origin_name
    #   @return [String] The name of the ODFI or sending point.
    # @!attribute [rw] reference_code
    #   @return [String] An optional code for the ODFI's use.
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
