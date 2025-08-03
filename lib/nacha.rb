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
require 'nacha/ach_file'
require 'nacha/version'
require 'nacha/aba_number'
require 'nacha/ach_date'
require 'nacha/field'
require 'nacha/numeric'

# Nacha is a Ruby gem for parsing, validating, and generating NACHA
# (National Automated Clearing House Association) files.
# It provides a structured way to work with ACH (Automated Clearing House) records,
# including various entry detail, addenda, batch, and file control records.
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

  class << self
    # Adds a new ACH record type class to the list of defined record types.
    # This is used internally by the parser to determine which record classes
    # are available for parsing a NACHA file.  As the `nacha_field` method is
    # executed for each of the record types, these record types are added to
    # the Nacha module's class variable `@@ach_record_types`.
    #
    # @param klass [Class, String] The record class or its name (as a String) to add.
    # @return [void]
    def add_ach_record_type(klass)
      return unless klass

      klass = klass.to_s
      @ach_record_types ||= []
      @ach_record_types << klass unless @ach_record_types.include?(klass)
    end

    # Returns an array of all currently registered ACH record type class names.
    #
    # @return [Array<String>] An array of ACH record class names.
    def ach_record_types
      @ach_record_types || []
    end

    def to_h
      types_hash = {}
      ach_record_types.each do |record_type|
        types_hash.merge! Object.const_get(record_type).to_h
      end
      types_hash
    end

    # Parses a NACHA file, string or url into a structured object representation.
    #
    # @param object [String, File, IO, URL] The input to parse, either a string containing
    #   NACHA data or an IO object (e.g., a File) representing the NACHA file.
    # @return [Nacha::AchFile] The parsed NACHA file object.
    def parse(object)
      ach_file = AchFile.new(object)
      ach_file.parse
    end

    # Converts a given string into a underscored, lowercase record name.
    # This is typically used to derive a human-readable or programmatic
    # name from a class name or similar string.
    #
    # @param str [String] The string to convert.
    # @return [String] The underscored and lowercased record name.
    def record_name(str)
      underscore(str.to_s).split('/').last
    end

    # Converts a camel-cased string to its underscore equivalent.
    # This method handles module namespaces (::) by converting them to slashes.
    #
    # @param str [String] The string to underscore.
    # @return [String] The underscored string.
    def underscore(str)
      str.gsub(/::/, '/')
         .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
         .gsub(/([a-z\d])([A-Z])/, '\1_\2')
         .tr('-', '_')
         .downcase
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

Gem.find_files('nacha/record/*.rb').reject { |f| f.include?('/spec/') }.each do |file|
  require File.expand_path(file)
end

Gem.find_files('nacha/record/**/*.rb').reject { |f| f.include?('/spec/') }.each do |file|
  require File.expand_path(file)
end

# Load the parser after the records have been defined

require 'nacha/parser'
