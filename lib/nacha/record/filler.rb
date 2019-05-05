# coding: utf-8
require 'nacha/record/base.rb'
require 'nacha/record/filler_record_type.rb'

module Nacha
  module Record
    class Filler < Nacha::Record::Base
      include FillerRecordType

    end
  end
end
