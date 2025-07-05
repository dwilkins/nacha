# frozen_string_literal: true

require 'json'
require 'nacha/field'
require 'nacha/record/validations/field_validations'

module Nacha
  module Record
    class Base
      include Validations::FieldValidations

      attr_accessor :children, :parent, :line_number
      attr_reader :name, :validations, :original_input_line, :fields

      def initialize(opts = {})
        @children = []
        @parent = nil
        @errors = []
        @original_input_line = nil
        create_fields_from_definition
        opts.each do |k, v|
          setter = "#{k}="
          next unless respond_to? setter

          # rubocop:disable GitlabSecurity/PublicSend
          send(setter, v) unless v.nil?
          # rubocop:enable GitlabSecurity/PublicSend
        end
      end

      class << self
        def nacha_field(name, inclusion:, contents:, position:)
          Nacha.add_ach_record_type(self)
          definition[name] = { inclusion: inclusion,
                               contents: contents,
                               position: position,
                               name: name }
          validation_method = :"valid_#{name}"
          return unless respond_to?(validation_method)

          validations[name] ||= []
          validations[name] << validation_method
        end

        def definition
          @definition ||= {}
        end

        def validations
          @validations ||= {}
        end

        def unpack_str
          @unpack_str ||= definition.values.collect do |d|
            Nacha::Field.unpack_str(d)
          end.join.freeze
        end

        # A more strict matcher that accounts for numeric and date fields
        # and allows for spaces in those fields, but not alphabetic characters
        # Also matches strings that might not be long enough.
        #
        # Processes the definition in reverse order to allow later fields to be
        # skipped if they are not present in the input string.
        def old_matcher
          return @matcher if @matcher

          output_started = false
          skipped_output = false
          @matcher ||=
            Regexp.new("\\A#{definition.values.reverse.collect do |field_def|
              if field_def[:contents] =~ /\AC(.+)\z/
                last_match = Regexp.last_match(1)
                if /\A  *\z/.match?(last_match)
                  skipped_output = true
                  ''
                else
                  output_started = true
                  last_match
                end
              elsif /\ANumeric\z/.match?(field_def[:contents])
                output_started = true
                "[0-9 ]{#{field_def[:position].size}}"
              elsif /\AYYMMDD\z/.match?(field_def[:contents])
                if output_started
                  "[0-9 ]{#{field_def[:position].size}}"
                else
                  skipped_output = true
                  ''
                end
              elsif output_started
                ".{#{field_def[:position].size}}"
              else
                skipped_output = true
                ''
              end
            end.reverse.join}#{skipped_output ? '.*' : ''}\\z")
        end

        def matcher
          return @matcher if @matcher

          output_started = false
          skipped_output = false
          @matcher ||=
            Regexp.new("\\A#{definition.values.reverse.collect do |field_def|
              contents = field_def[:contents]
              position = field_def[:position].size
              case contents
              when /\AC(.+)\z/
                last_match = Regexp.last_match(1)
                if last_match.match?(/\A  *\z/)
                  skipped_output = true
                  ''
                else
                  output_started = true
                  last_match
                end
              when /\ANumeric\z/, /\AYYMMDD\z/
                if output_started
                  "[0-9 ]{#{position}}"
                else
                  skipped_output = true
                  ''
                end
              else
                if output_started
                  ".{#{position}}"
                else
                  skipped_output = true
                  ''
                end
              end
            end.reverse.join}#{skipped_output ? '.*' : ''}\\z")
        end

        def parse(ach_str)
          rec = new(original_input_line: ach_str)
          ach_str.unpack(unpack_str).zip(rec.fields.values) do |input_data, field|
            field.data = input_data
          end
          rec.validate
          rec
        end

        def record_type
          Nacha.record_name(self)
        end

        def to_h
          fields = definition.map do |name, field_def|
            [name, {
              inclusion: field_def[:inclusion],
              contents: field_def[:contents],
              position: field_def[:position].to_s
            }]
          end.to_h

          if respond_to?(:child_record_types)
            fields[:child_record_types] = child_record_types
          end

          { record_type.to_sym => fields }
        end

        def to_json(*_args)
          JSON.pretty_generate(to_h)
        end
      end

      def original_input_line=(line)
        @original_input_line = line.dup if line.is_a?(String)
      end

      def create_fields_from_definition
        @fields ||= {}
        definition.each_pair do |field_name, field_def|
          @fields[field_name.to_sym] = Nacha::Field.new(field_def)
        end
      end

      def record_type
        self.class.record_type
      end

      def human_name
        @human_name ||= record_type.to_s.split('_').map(&:capitalize).join(' ')
      end

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

      def to_json(*_args)
        JSON.pretty_generate(to_h)
      end

      def to_ach
        @fields.keys.collect do |key|
          @fields[key].to_ach
        end.join
      end

      def to_html(_opts = {})
        record_error_class = nil

        field_html = @fields.keys.collect do |key|
          record_error_class ||= 'error' if @fields[key].errors.any?
          @fields[key].to_html
        end.join
        "<div class=\"nacha-record tooltip #{record_type} #{record_error_class}\">" \
          "<span class=\"nacha-field\" data-name=\"record-number\">#{format('%05d',
            line_number)}&nbsp;|&nbsp</span>" \
          "#{field_html}" \
          "<span class=\"record-type\" data-name=\"record-type\">#{human_name}</span>" \
          "</div>"
      end

      def inspect
        "#<#{self.class.name}> #{to_h}"
      end

      def definition
        self.class.definition
      end

      def validate
        # Run field-level validations first
        @fields.each_value(&:validate)
        klass = self.class
        klass_def = klass.definition
        klass_validations = klass.validations
        # Then run record-level validations that might depend on multiple fields
        klass_def.each_key do |field|
          fv = klass_validations[field]
          next unless fv

          # rubocop:disable GitlabSecurity/PublicSend
          field_data = send(field)

          fv.map do |validation_method|
            klass.send(validation_method, field_data)
          end
          # rubocop:enable GitlabSecurity/PublicSend
        end
      end

      # look for invalid fields, if none, then return true
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

      def errors
        (@errors + @fields.values.map(&:errors)).flatten
      end

      def add_error(err_string)
        @errors << err_string
      end

      def method_missing(method_name, *args, &block)
        method = method_name.to_s
        field_name = method.gsub(/=$/, '').to_sym
        field = @fields[field_name]

        if field && method.end_with?('=')
          # rubocop:disable GitlabSecurity/PublicSend
          field.public_send(:data=, *args)
          # rubocop:enable GitlabSecurity/PublicSend
          @dirty = true
        elsif field
          field
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        field_name = method_name.to_s.gsub(/=$/, '').to_sym
        definition[field_name] || super
      end
    end
  end
end
