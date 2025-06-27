# frozen_string_literal: true

# Uncomment to use debugger
# if RUBY_ENGINE == 'ruby'
#   require "byebug"
# end
#
# if RUBY_ENGINE == 'jruby'
#   require "pry-nav"
# end

require 'yaml'
require 'nacha/version'
require 'nacha/aba_number'
require 'nacha/ach_date'
require 'nacha/field'
require 'nacha/numeric'

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
  @@ach_record_types = []

  def self.add_ach_record_type(klass)
    return unless klass
    @@ach_record_types << klass unless @@ach_record_types.include?(klass)
  end

  def self.ach_record_types
    @@ach_record_types
  end

  class << self
    def parse(object)
      parser = Nacha::Parser.new
      if object.is_a?(String)
        parser.parse_string(object)
      else
        parser.parse_file(object)
      end
    end

    def record_name(str)
      underscore(str.to_s).split('/').last
    end

    def underscore(str)
      str.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr('-', '_').
        downcase
    end
  end
end

# Load all record types from nacha/record/*.rb and nacha/record/**/*.rb
# This will ensure that all record classes are loaded before the parser is used

require 'nacha/record/base'
require 'nacha/record/file_header_record_type'
require 'nacha/record/file_control_record_type'
require 'nacha/record/detail_record_type'

# Ensure that the record types are loaded before the parser is used
# This is necessary because the parser relies on the record types being defined
# and available in the Nacha module.

Gem.find_files('nacha/record/*.rb').reject{|f| f =~ /\/spec\//}.each do |file|
  require File.expand_path(file)
end

Gem.find_files('nacha/record/**/*.rb').reject{|f| f =~ /\/spec\//}.each do |file|
  require File.expand_path(file)
end

# Load the parser after the records have been defined

require 'nacha/parser'

