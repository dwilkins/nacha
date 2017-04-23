# require "nacha/record/addenda_record_type"
# require "nacha/record/control_record_type"
# require "nacha/record/header_record_type"
# require "nacha/record/detail_record_type"
# require "nacha/record/filler_record_type"
require 'json'

module Nacha
  module Record
    class Base
      attr_accessor :children, :fields
      attr_reader :definition, :name

      @@unpack_str = nil
      @@matcher = nil

      RECORD_DEFINITION = {  }  # Set by the child classes
      RECORD_NAME = ''

      def initialize opts = {}
        create_fields_from_definition
        opts.each do |k,v|
          setter = "#{k}="
          if(respond_to?(setter))
            send(setter, v) unless v.nil?
          end
        end
      end

      def create_fields_from_definition
        @fields ||= {  }
        definition.each_pair do |field_name, field_def|
          @fields[field_name.to_sym] = Nacha::Field.new(field_def)
        end
      end

      def to_h
        @fields.keys.collect do |key|
          [key,@fields[key].to_json_output]
        end.to_h
      end

      def to_json
        # to_h.to_json
        JSON.pretty_generate(to_h)
      end

      def self.definition
        const_get("RECORD_DEFINITION")
      end

      def self.name
        const_get("RECORD_NAME")
      end

      def definition
        self.class.definition
      end

      def self.unpack_str
        @unpack_str ||= definition.values.collect {|d|
          'A' + d['position'].size.to_s
        }.join.freeze
      end

      def self.matcher
        @matcher ||=
          definition['matcher'] ||
          Regexp.new('\A' + definition.values.collect do |d|
                       if(d['contents'] =~ /\AC(.*)\z/)
                         $1
                       else
                         '.' * d['position'].size
                       end
                     end.join + '\z')
      end


      def self.parse ach_str
        rec = self.new
        ach_str.unpack(self.unpack_str).zip(rec.fields.values) { |input_data, field|
          field.data = input_data
        }
        rec
      end

      def respond_to?(method_name, include_private = false)
        field_name = method_name.to_s.gsub(/=$/,'').to_sym
        definition[field_name] || super
      end

      def method_missing(method_name, *args, &block)
        field_name = method_name.to_s.gsub(/=$/,'').to_sym
        is_assignment = (/[^=]*=$/o =~ method_name.to_s)
        if @fields[field_name]
          if is_assignment
            # @fields[field_name].send(:data=,*args)
            @fields[field_name].send(:data=,*args)
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
