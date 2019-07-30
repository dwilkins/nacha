# frozen_string_literal: true

require 'nacha/version'
require 'yaml'
require 'nacha/aba_number'
require 'nacha/ach_date'
require 'nacha/field'
require 'nacha/numeric'

Dir['lib/nacha/record/*.rb'].each do |file|
  require File.expand_path(file)
end

Dir['lib/nacha/record/**/*.rb'].each do |file|
  require File.expand_path(file)
end

require 'nacha/parser'

module Nacha
  STANDARD_ENTRY_CLASS_CODES = %w[ACK ADV ARC ATX BOC CCD PPD CIE
                                  COR CTX DNE ENR IAT POP POS SHR
                                  MTE RCK TEL TRC TRX WEB XCK].freeze

  SERVICE_CLASS_CODES = %w[200 220 225 280].freeze

  CREDIT_TRANSACTION_CODES = %w[20 21 22 23 24 30 31 32 33 34 41 42
                                43 44 51 52 53 54 81 83 85 87].freeze
  DEBIT_TRANSACTION_CODES  = %w[25 26 27 28 29 35 36 37 38 39 46 47
                                48 49 55 56 82 84 86 88].freeze

  TRANSACTION_CODES = (CREDIT_TRANSACTION_CODES + DEBIT_TRANSACTION_CODES).freeze

  def self.record_name(str)
    underscore(str.to_s).split('/').last
  end

  def self.underscore(str)
    str.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr('-', '_').
      downcase
  end
end
