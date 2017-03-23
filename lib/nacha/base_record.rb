require "nacha/record/addenda_record_type"
require "nacha/record/control_record_type"
require "nacha/record/header_record_type"
require "nacha/record/detail_record_type"
require "nacha/record/filler_record_type"


class Nacha::BaseRecord
  attr_accessor :children, :record_name, :fields
  attr_reader :definition

  RECORD_DEFINITION = {  }  # Set by the child classes

  def initialize opts = {}
    create_fields_from_definition
    opts.each do |k,v|
      puts "k = #{k}"
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

  def self.definition
    const_get("RECORD_DEFINITION")
  end

  def definition
    self.class.definition
  end

  def fields
  end


  def respond_to?(method_name, include_private = false)
    puts "Checking for #{method_name}"
    field_name = method_name.to_s.gsub(/=$/,'').to_sym
    definition[field_name] || super
  end

  def method_missing(method_name, *args, &block)
    puts "method_missing Checking for #{method_name}"
    field_name = method_name.to_s.gsub(/=$/,'').to_sym
    puts "method_missing actually Checking for #{field_name}"
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
