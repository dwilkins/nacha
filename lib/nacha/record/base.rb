# frozen_string_literal: true

require 'json'
require 'nacha/field'
require 'nacha/record/validations/field_validations'

# :reek:TooManyInstanceVariables, :reek:TooManyMethods
module Nacha
  module Record
    # Base class for all Nacha records.
    # @!attribute [r] children
    #   @return [Array<Nacha::Record::Base>] An array of child records associated with this record.
    # @!attribute [r] original_input_line
    #   @return [String, nil] The original string from the ACH file that this record was parsed from.
    # @!attribute [r] fields
    #   @return [Hash{Symbol => Nacha::Field}] A hash of field objects that belong to this record, keyed by field name.
    # @!attribute [rw] parent
    #   @return [Nacha::Record::Base, nil] The parent record of this record in the ACH file hierarchy.
    # @!attribute [rw] line_number
    #   @return [Integer, nil] The line number of this record within the ACH file.
    class Base
      include Validations::FieldValidations

      attr_reader :children, :name, :validations, :original_input_line, :fields

      # :reek:Attribute

      attr_accessor :parent, :line_number

      # :reek:ManualDispatch

      # Initializes a new record object.
      # @param opts [Hash] A hash of options to set as attributes on the new record.
      def initialize(opts = {})
        @children = []
        @parent = nil
        @errors = []
        @original_input_line = nil
        @line_number = nil
        @dirty = false
        @fields = {}
        create_fields_from_definition
        opts.each do |key, value|
          setter = "#{key}="
          # rubocop:disable GitlabSecurity/PublicSend
          public_send(setter, value) if value && respond_to?(setter)
          # rubocop:enable GitlabSecurity/PublicSend
        end
      end

      class << self
        # :reek:LongParameterList, :reek:ManualDispatch
        # Defines a field for the record type.
        #
        # This class method is used in subclasses to declare each field within the NACHA record.
        # It stores the definition and sets up validations.
        #
        # @param name [Symbol] The name of the field.
        # @param inclusion [String] The inclusion rule for the field ('M' for mandatory, 'R' for required, 'O' for optional).
        # @param contents [String] The expected content type of the field (e.g., 'Numeric', 'Alphameric', 'C...').
        # @param position [Range] The character position range of the field in the record string.
        # @return [void]
        def nacha_field(name, inclusion:, contents:, position:)
          Nacha.add_ach_record_type(self)
          definition[name] = { inclusion: inclusion,
                               contents: contents,
                               position: position,
                               name: name }
          validation_method = :"valid_#{name}"
          return unless respond_to?(validation_method)

          (validations[name] ||= []) << validation_method
        end

        # Returns the field definitions for the record class.
        # @return [Hash] A hash containing the definitions of all fields for this record type.
        def definition
          @definition ||= {}
        end

        # Returns the validation methods for the record class.
        # @return [Hash] A hash of validation methods for the fields of this record type.
        def validations
          @validations ||= {}
        end

        # Generates and returns a format string for `String#unpack` to parse a record line.
        #
        # The format string is built based on the field definitions.
        # @return [String] The unpack format string.
        def unpack_str
          @unpack_str ||= definition.values
                            .sort { |a, b| a[:position].first <=> b[:position].first }
                            .collect do |field_def|
            Nacha::Field.unpack_str(field_def)
          end.join.freeze
        end

        # :reek:TooManyStatements
        # rubocop:disable Layout/BlockAlignment,
        # rubocop:disable Style/StringConcatenation:

        # Generates a Regexp to match against a line to determine if it is of this record type.
        # @return [Regexp] The regular expression for matching record lines.
        def matcher
          @matcher ||= begin
            output_started = false
            skipped_output = false
            Regexp.new('\A' + definition.values
                                .sort { |a,b| a[:position].first <=> b[:position].first }.reverse.collect do |field|
                         contents = field[:contents]
                         position = field[:position]
                         size = position.size
                         if contents =~ /\AC(.+)\z/
                           last_match = Regexp.last_match(1)
                           if last_match.match?(/  */) && !output_started
                             skipped_output = true
                             ''
                           else
                             output_started = true
                             last_match
                           end
                         elsif contents.match?(/\ANumeric\z/) || contents.match?(/\AYYMMDD\z/)
                           output_started = true
                           "[0-9 ]{#{size}}"
                         elsif output_started
                           ".{#{size}}"
                         else
                           skipped_output = true
                           ''
                         end
                       end.reverse.join + (skipped_output ? '.*' : '') + '\z')
          end
        end
        # rubocop:enable Layout/BlockAlignment,
        # rubocop:enable Style/StringConcatenation:

        # Parses an ACH string and creates a new record instance.
        #
        # It unpacks the string based on field definitions, populates the fields,
        # and runs validations.
        # @param ach_str [String] The 94-character string representing a NACHA record.
        # @return [Nacha::Record::Base] A new instance of the record class populated with data from the string.
        def parse(ach_str)
          rec = new(original_input_line: ach_str)
          ach_str.unpack(unpack_str).zip(rec.fields.values) do |input_data, field|
            field.data = input_data
          end
          rec.validate
          rec
        end

        # Returns the record type name.
        #
        # The name is derived from the class name, converted to a snake_case symbol.
        # @return [Symbol] The record type as a symbol (e.g., :file_header).
        def record_type
          Nacha.record_name(self)
        end

        # Returns a hash representation of the record class definition.
        #
        # This includes field definitions and child record types.
        # @return [Hash] A hash representing the structure of the record type.
        def to_h # :reek:ManualDispatch, :reek:TooManyStatements
          fields = definition.transform_values do |field_def|
            {
              inclusion: field_def[:inclusion],
              contents: field_def[:contents],
              position: field_def[:position].to_s
            }
          end

          fields[:child_record_types] = child_record_types.to_a
          fields[:child_record_types] ||= []
          fields[:klass] = name.to_s

          { record_type.to_sym => fields }
        end

        # Returns a JSON string representing the record class definition.
        # @param _args [Array] Arguments to be passed to `JSON.pretty_generate`.
        # @return [String] The JSON representation of the record definition.
        def to_json(*_args)
          JSON.pretty_generate(to_h)
        end
      end

      # :reek:FeatureEnvy

      # Sets the original input line string for the record.
      # @param line [String] The original 94-character string from the ACH file.
      # @return [void]
      def original_input_line=(line)
        @original_input_line = line.dup if line.is_a?(String)
      end

      # Creates field instances from the class's field definitions.
      #
      # This method is called during initialization to populate the `@fields` hash.
      # @return [void]
      def create_fields_from_definition
        definition.each_pair do |field_name, field_def|
          @fields[field_name.to_sym] = Nacha::Field.new(field_def)
        end
      end

      # Returns the record type name for the instance.
      # @return [Symbol] The record type as a symbol.
      # @see .record_type
      def record_type
        self.class.record_type
      end

      # Returns a human-readable name for the record type.
      #
      # It converts the snake_case `record_type` into a capitalized string with spaces.
      # @return [String] The human-readable name (e.g., 'File Header').
      def human_name
        @human_name ||= record_type.to_s.split('_').map(&:capitalize).join(' ')
      end

      # Returns a hash representation of the record instance.
      #
      # The hash includes metadata and a representation of each field's data and errors.
      # @return [Hash] A hash representing the record's current state.
      def to_h
        { nacha_record_type: record_type,
          metadata: {
            klass: self.class.name,
            errors: errors,
            line_number: @line_number,
            original_input_line: original_input_line
          } }.merge(
            @fields.keys.to_h do |key|
              [key, @fields[key].to_json_output]
            end)
      end

      # Returns a JSON string representing the record instance.
      # @param _args [Array] Arguments to be passed to `JSON.pretty_generate`.
      # @return [String] The JSON representation of the record's current state.
      def to_json(*_args)
        JSON.pretty_generate(to_h)
      end

      # Generates the 94-character ACH string representation of the record.
      #
      # This is done by concatenating the ACH string representation of each field.
      # @return [String] The 94-character ACH record string.
      def to_ach
        @fields.keys.collect do |key|
          @fields[key].to_ach
        end.join
      end

      # Generates an HTML representation of the record.
      #
      # This is useful for displaying ACH data in a web interface.
      # @param _opts [Hash] Options for HTML generation (currently unused).
      # @return [String] The HTML representation of the record.
      def to_html(_opts = {})
        record_error_class = nil

        field_html = @fields.values.collect do |field|
          record_error_class ||= 'error' if field.errors.any?
          field.to_html
        end.join
        "<div class=\"nacha-record tooltip #{record_type} #{record_error_class}\">" \
          "<span class=\"nacha-record-number\" data-name=\"record-number\">#{format('%05d',
            line_number)}&nbsp;|&nbsp</span>" \
          "#{field_html}" \
          "<span class=\"record-type\" data-name=\"record-type\">#{human_name}</span>" \
          "</div>"
      end

      # Returns a developer-friendly string representation of the record object.
      # @return [String] A string showing the class name and a hash representation of the object.
      def inspect
        "#<#{self.class.name}> #{to_h}"
      end

      # Returns the field definitions for the record class.
      # @return [Hash] A hash containing the definitions of all fields for this record type.
      # @see .definition
      def definition
        self.class.definition
      end

      # Runs all field-level and record-level validations.
      #
      # This method populates the `errors` array on the record and its fields.
      # @return [void]
      def validate
        # Run field-level validations first
        @fields.each_value(&:validate)
        # Then run record-level validations that might depend on multiple fields
        self.class.definition.each_key do |field|
          run_record_level_validations_for(field)
        end
      end

      # Checks if the record is valid by running all validations.
      # @return [Boolean] `true` if the record has no errors, `false` otherwise.
      def valid?
        validate
        errors.empty?
      end

      # Checks if the current transaction code represents a debit transaction.
      #
      # This method evaluates the `transaction_code` (which is expected to be
      # an attribute or method available in the current context) against a
      # predefined set of debit transaction codes.
      #
      # @return [Boolean] `true` if `transaction_code` is present and its
      #   string representation is included in `DEBIT_TRANSACTION_CODES`,
      #   `false` otherwise.
      #
      # @example
      #   # Assuming transaction_code is "201" and DEBIT_TRANSACTION_CODES includes "201"
      #   debit? #=> true
      #
      #   # Assuming transaction_code is "100" and DEBIT_TRANSACTION_CODES
      #   # does not include "100"
      #   debit? #=> false
      #
      #   # Assuming transaction_code is nil
      #   debit? #=> false
      #
      # @note
      #   This method includes robust error handling. If a `NoMethodError`
      #   occurs (e.g., if `transaction_code` is undefinable or does not respond
      #   to `to_s` in an unexpected way) or a `NameError` occurs (e.g., if
      #   `transaction_code` or `DEBIT_TRANSACTION_CODES` is not defined
      #   in the current scope), the method gracefully rescues these exceptions
      #   and returns `false`. This default behavior ensures that an inability
      #   to determine the transaction type results in it being considered
      #   "not a debit".
      #
      # @see #transaction_code (if `transaction_code` is an instance method or attribute)
      # @see DEBIT_TRANSACTION_CODES (the constant defining debit codes)
      def debit?
        transaction_code &&
          DEBIT_TRANSACTION_CODES.include?(transaction_code.to_s)
      rescue NoMethodError, NameError
        false
      end

      # Checks if the current transaction code represents a credit transaction.
      #
      # This method evaluates the `transaction_code` (which is expected to be
      # an attribute or method available in the current context) against a
      # predefined set of credit transaction codes.
      #
      # @return [Boolean] `true` if `transaction_code` is present and its
      #   string representation is included in `CREDIT_TRANSACTION_CODES`,
      #   `false` otherwise.
      #
      # @example
      #   # Assuming transaction_code is "101" and CREDIT_TRANSACTION_CODES includes "101"
      #   credit? #=> true
      #
      #   # Assuming transaction_code is "200" and CREDIT_TRANSACTION_CODES
      #   # does not include "200"
      #   credit? #=> false
      #
      #   # Assuming transaction_code is nil
      #   credit? #=> false
      #
      # @note
      #   This method includes robust error handling. If a `NoMethodError`
      #   occurs (e.g., if `transaction_code` is undefinable or does not respond
      #   to `to_s` in an unexpected way) or a `NameError` occurs (e.g., if
      #   `transaction_code` or `CREDIT_TRANSACTION_CODES` is not defined
      #   in the current scope), the method gracefully rescues these exceptions
      #   and returns `false`. This default behavior ensures that an inability
      #   to determine the transaction type results in it being considered
      #   "not a credit".
      #
      # @see #transaction_code (if `transaction_code` is an instance method or attribute)
      # @see CREDIT_TRANSACTION_CODES (the constant defining credit codes)
      def credit?
        transaction_code &&
          CREDIT_TRANSACTION_CODES.include?(transaction_code.to_s)
      rescue NoMethodError, NameError
        false
      end

      # Returns all validation errors for the record and its fields.
      # @return [Array<String>] An array of error messages.
      def errors
        (@errors + @fields.values.map(&:errors)).flatten
      end

      # Adds a validation error message to the record's error list.
      # @param err_string [String] The error message to add.
      # @return [void]
      def add_error(err_string)
        @errors << err_string
      end

      # :reek:TooManyStatements

      # Handles dynamic access to fields as methods.
      #
      # This allows getting and setting field data using attribute-style methods
      # (e.g., `record.amount`, `record.amount = 123.45`).
      # @param method_name [Symbol] The name of the missing method.
      # @param args [Array] The arguments passed to the method.
      # @param block [Proc] A block passed to the method.
      # @return [Nacha::Field, Object] Returns the `Nacha::Field` object for a getter, or the assigned value for a setter.
      def method_missing(method_name, *args, &block)
        method = method_name.to_s
        field_name = method.gsub(/=$/, '').to_sym
        field = @fields[field_name]
        return super unless field

        if method.end_with?('=')
          assign_field_data(field, args)
        else
          field
        end
      end

      # Complements `method_missing` to allow `respond_to?` to work for dynamic field methods.
      # @param method_name [Symbol] The name of the method to check.
      # @param _ [Array] Additional arguments (e.g. `include_private`) are ignored.
      # @return [Boolean] `true` if the method corresponds to a defined field, `false` otherwise.
      def respond_to_missing?(method_name, *)
        field_name = method_name.to_s.gsub(/=$/, '').to_sym
        definition[field_name] || super
      end

      private

      def assign_field_data(field, args)
        # rubocop:disable GitlabSecurity/PublicSend
        field.public_send(:data=, *args)
        # rubocop:enable GitlabSecurity/PublicSend
        @dirty = true
      end

      # :reek:TooManyStatements

      def run_record_level_validations_for(field)
        klass = self.class
        validations = klass.validations[field]
        return unless validations

        # rubocop:disable GitlabSecurity/PublicSend
        field_data = send(field)

        validations.each do |validation_method|
          klass.send(validation_method, field_data)
        end
        # rubocop:enable GitlabSecurity/PublicSend
      end
    end
  end
end
