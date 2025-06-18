# frozen_string_literal: true

require 'json'
require 'nacha/field'
require 'nacha/record/validations/field_validations'
require 'byebug'
module Nacha
  module Record
    class Base
      include Validations::FieldValidations

      attr_accessor :children, :parent, :fields
      attr_reader :name, :validations, :errors, :original_input_line
      attr_accessor :line_number

      def initialize(opts = {})
        @children = []
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
        attr_reader :nacha_record_name

        def nacha_field(name, inclusion:, contents:, position:)
          definition[name] = { inclusion: inclusion,
                               contents: contents,
                               position: position,
                               name: name}
          validation_method = "valid_#{name}".to_sym
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

        def old_matcher
          @matcher ||=
            Regexp.new('\A' + definition.values.collect do |d|
                         if d[:contents] =~ /\AC(.+)\z/ || d['contents'] =~ /\AC(.+)\z/
                           Regexp.last_match(1)
                         else
                           '.' * (d[:position] || d['position']).size
                         end
                       end.join + '\z')
        end

        # A more strict matcher that accounts for numeric and date fields
        # and allows for spaces in those fields, but not alphabetic characters
        # Also matches strings that might not be long enough.
        #
        # Processes the definition in reverse order to allow later fields to be
        # skipped if they are not present in the input string.
        def matcher
          return @matcher if @matcher

          output_started = false
          skipped_output = false
          @matcher ||=
            Regexp.new('\A' + definition.values.reverse.collect do |d|
                         if d[:contents] =~ /\AC(.+)\z/
                           output_started = true
                           Regexp.last_match(1)
                         elsif d[:contents] =~ /\ANumeric\z/
                           if output_started
                             '[0-9 ]' + "{#{(d[:position] || d['position']).size}}"
                           else
                             skipped_output = true
                             ''
                           end
                         elsif d[:contents] =~ /\AYYMMDD\z/
                           if output_started
                             '[0-9 ]' + "{#{(d[:position] || d['position']).size}}"
                           else
                             skipped_output = true
                             ''
                           end
                         else
                           if output_started
                             '.' + "{#{(d[:position] || d['position']).size}}"
                           else
                             skipped_output = true
                             ''
                           end
                         end
                       end.reverse.join + (skipped_output ? '.*' : '') + '\z')
        end


        def parse(ach_str)
          rec = new
          ach_str.unpack(unpack_str).zip(rec.fields.values) do |input_data, field|
            field.data = input_data
          end
          rec.original_input_line = ach_str
          rec.validate
          rec
        end
      end # end class methods

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
        Nacha.record_name(self.class)
      end

      def human_name
        @human_name ||= record_type.to_s.split('_').map(&:capitalize).join(' ')
      end

      def to_h
        { nacha_record_type: record_type,
          metadata: {
            errors: errors,
            line_number: @line_number,
            original_input_line: original_input_line
          }
        }.merge(
          @fields.keys.map do |key|
            [key, @fields[key].to_json_output]
          end.to_h)
      end

      def to_json(*_args)
        JSON.pretty_generate(to_h)
      end

      def to_ach
        @fields.keys.collect do |key|
          @fields[key].to_ach
        end.join
      end

      def to_html(opts = {})
        record_error_class = nil

        field_html = @fields.keys.collect do |key|
          record_error_class ||= 'error' if @fields[key].errors.any?
          @fields[key].to_html
        end.join
        "<div class=\"nacha-record tooltip #{record_type} #{record_error_class}\">" +
          "<span class=\"nacha-field\" data-name=\"record-number\">#{"%05d" % [line_number]}&nbsp;|&nbsp</span>" +
          field_html +
          "<span class=\"record-type\" data-name=\"record-type\">#{human_name}</span>" +
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
        @fields.values.each(&:validate)

        # Then run record-level validations that might depend on multiple fields
        self.class.definition.keys.each do |field|
          next unless self.class.validations[field]

          # rubocop:disable GitlabSecurity/PublicSend
          field_data = send(field)

          self.class.validations[field].map do |validation_method|
            self.class.send(validation_method, field_data)
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
      #   # Assuming transaction_code is "100" and DEBIT_TRANSACTION_CODES does not include "100"
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
      #   # Assuming transaction_code is "200" and CREDIT_TRANSACTION_CODES does not include "200"
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
        (@errors + @fields.values.map { |field| field.errors }).flatten
      end


      def add_error(err_string)
        @errors << err_string
      end

      def respond_to?(method_name, include_private = false)
        field_name = method_name.to_s.gsub(/=$/, '').to_sym

        definition[field_name] || super
      end

      def method_missing(method_name, *args, &block)
        field_name = method_name.to_s.gsub(/=$/, '').to_sym
        is_assignment = (/[^=]*=$/o =~ method_name.to_s)
        if @fields[field_name]
          if is_assignment
            # @fields[field_name].send(:data=,*args)
            # rubocop:disable GitlabSecurity/PublicSend
            @fields[field_name].public_send(:data=, *args)
            # rubocop:enable GitlabSecurity/PublicSend
            @dirty = true
          else
            # @fields[field_name].data
            @fields[field_name]
          end
        else
          super
        end
      end
    end
  end
end
