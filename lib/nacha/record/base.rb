# frozen_string_literal: true

require 'json'
require 'nacha/field'
require 'nacha/record/validations/field_validations'

module Nacha
  module Record
    class Base
      include Validations::FieldValidations

      attr_accessor :children, :parent, :fields
      attr_reader :name, :validations
      attr_accessor :line_number

      def initialize(opts = {})
        @children = []
        create_fields_from_definition
        opts.each do |k, v|
          setter = "#{k}="
          next unless respond_to? setter

          # rubocop:disable GitlabSecurity/PublicSend
          send(setter, v) unless v.nil?
          # rubocop:enable GitlabSecurity/PublicSend
        end
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

      def to_h
        { nacha_record_type: record_type }.merge(
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

      def to_html
        "<div style=\"font-family: monospace;\"class='nacha-record tooltip #{record_type}'>" +
          "<span class='tooltiptext'>#{record_type}</span>" +
          "<span class='nacha-field' data-name='record-number'>#{"%05d" % [line_number]}&nbsp;|&nbsp</span>" +
        @fields.keys.collect do |key|
          @fields[key].to_html
        end.join + "</div>"
      end

      def inspect
        "#<#{self.class.name}> #{to_h}"
      end

      def self.nacha_field(name, inclusion:, contents:, position:)
        definition[name] = { inclusion: inclusion,
                             contents: contents,
                             position: position,
                             name: name}
        validation_method = "valid_#{name}".to_sym
        return unless respond_to?(validation_method)

        validations[name] ||= []
        validations[name] << validation_method
      end

      def self.definition
        @definition ||= {}
      end

      def self.validations
        @validations ||= {}
      end

      class << self
        attr_reader :nacha_record_name
      end

      def definition
        self.class.definition
      end

      def validate
        self.class.definition.keys.map do |field|
          next unless self.class.validations[field]

          # rubocop:disable GitlabSecurity/PublicSend
          field_data = send(field)
          send(self.class.validations[:field], field_data)
          # rubocop:enable GitlabSecurity/PublicSend
        end
      end

      # look for invalid fields, if none, then return true
      def valid?
        statuses = self.class.definition.keys.map do |field_sym|
          # rubocop:disable GitlabSecurity/PublicSend
          field = send(field_sym)
          # rubocop:enable GitlabSecurity/PublicSend
          next true unless field.mandatory?

          ## TODO: levels of validity with 'R' and 'O' fields
          field.valid?
        end
        !statuses.detect { |valid| valid == false }
      end

      def debit?
        transaction_code &&
          DEBIT_TRANSACTION_CODES.include?(transaction_code.to_s)
      end

      def credit?
        transaction_code &&
          CREDIT_TRANSACTION_CODES.include?(transaction_code.to_s)
      end

      def self.unpack_str
        @unpack_str ||= definition.values.collect do |d|
          Nacha::Field.unpack_str(d)
        end.join.freeze
      end

      def self.matcher
        # puts definition.keys.join(', ')
        definition['matcher'] ||
          Regexp.new('\A' + definition.values.collect do |d|
                              if d[:contents] =~ /\AC(.+)\z/ || d['contents'] =~ /\AC(.+)\z/
                                Regexp.last_match(1)
                              else
                                '.' * (d[:position] || d['position']).size
                              end
                            end.join + '\z')
      end

      def self.parse(ach_str)
        rec = new
        ach_str.unpack(unpack_str).zip(rec.fields.values) do |input_data, field|
          field.data = input_data
        end
        rec
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
