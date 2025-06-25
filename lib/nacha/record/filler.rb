# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base.rb'
require 'nacha/record/filler_record_type.rb'

module Nacha
  module Record
    class Filler < Nacha::Record::Base
      include FillerRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C9', position: 1..1
      nacha_field :filler, inclusion: 'M', contents: ('C' + ('9' * 93)), position: 2..94
    end
  end
end
