require "nacha/record/addenda_record_type"
require "nacha/record/control_record_type"
require "nacha/record/header_record_type"
require "nacha/record/detail_record_type"
require "nacha/record/filler_record_type"


class Nacha::BaseRecord
  attr_accessor :definition, :children, :record_name, :fields

  def initialize opts = {}
    @fields = {}
    opts.each do |k,v|
      puts "k = #{k}"
      setter = "#{k}="
      if(respond_to?(setter))
        send(setter, v) unless v.nil?
      end
    end
  end


  def definition= record_def
    @record_name = record_def.keys.first
    @fields = record_def[@record_name]['fields'].collect do |field|
      [field[0].to_sym, Nacha::Field.new(field[1])]
    end.to_h
  end

  def field
    @fields
  end


 def respond_to?(method_name, include_private = false)
   field_name = method_name.to_s.gsub(/=$/,'').to_sym
   @fields[field_name] || super
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
