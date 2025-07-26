# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/file_header_record_type'

module Nacha
  module Record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an ADV File Header record with a constant value of '1'.
    # @!attribute [rw] priority_code
    #   @return [Nacha::Numeric] A code that indicates the processing priority of the file.
    # @!attribute [rw] immediate_destination
    #   @return [Nacha::AbaNumber] The routing number of the ACH Operator or receiving point to which the file is sent.
    # @!attribute [rw] immediate_origin
    #   @return [Nacha::AbaNumber] The routing number of the ACH Operator that is sending the file.
    # @!attribute [rw] file_creation_date
    #   @return [String] The date the file was created by the sending institution, in YYMMDD format.
    # @!attribute [rw] file_creation_time
    #   @return [String] The time the file was created by the sending institution, in HHMM format.
    # @!attribute [rw] file_id_modifier
    #   @return [String] A code to distinguish between multiple files created on the same date with the same origin and destination.
    # @!attribute [rw] record_size
    #   @return [String] The number of characters in each record of the file, which is always '094'.
    # @!attribute [rw] blocking_factor
    #   @return [String] The number of records in a block, which is always '10'.
    # @!attribute [rw] format_code
    #   @return [String] A code indicating the file format version, which is '1' for current Nacha standards.
    # @!attribute [rw] immediate_destination_name
    #   @return [String] The name of the ACH Operator or receiving point to which the file is being sent.
    # @!attribute [rw] immediate_origin_name
    #   @return [String] The name of the ACH Operator that is sending the file.
    # @!attribute [rw] reference_code
    #   @return [String] A reference code for the file, which is 'ADV FILE' for Automated Accounting Advices.
    class AdvFileHeader < Nacha::Record::Base
      include FileHeaderRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C1', position: 1..1
      nacha_field :priority_code, inclusion: 'R', contents: 'Numeric', position: 2..3
      nacha_field :immediate_destination, inclusion: 'M',
        contents: 'bTTTTAAAAC', position: 4..13
      nacha_field :immediate_origin, inclusion: 'M',
        contents: 'bTTTTAAAAC', position: 14..23
      nacha_field :file_creation_date, inclusion: 'M', contents: 'YYMMDD', position: 24..29
      nacha_field :file_creation_time, inclusion: 'M', contents: 'HHMM', position: 30..33
      nacha_field :file_id_modifier, inclusion: 'M', contents: 'A-Z0-9', position: 34..34
      nacha_field :record_size, inclusion: 'M', contents: 'C094', position: 35..37
      nacha_field :blocking_factor, inclusion: 'M', contents: 'C10', position: 38..39
      nacha_field :format_code, inclusion: 'M', contents: 'C1', position: 40..40
      nacha_field :immediate_destination_name, inclusion: 'M',
        contents: 'Alphameric', position: 41..63
      nacha_field :immediate_origin_name, inclusion: 'M',
        contents: 'Alphameric', position: 64..86
      nacha_field :reference_code, inclusion: 'M', contents: 'CADV FILE', position: 87..94
    end
  end
end
