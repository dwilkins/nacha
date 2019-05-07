require 'nacha'

class Nacha::Parser

  DEFAULT_RECORD_TYPES = [ 'Nacha::Record::FileHeader' ]
  def initialize
    reset!
  end

  def reset!
  end

  def parse_file(file)
    parent = nil
    records = []
    File.foreach(file).with_index do |line, line_num|
      records << process(line,line_num, records.last)
      parent = records.last if records.lasts.class.child_record_types.any?
    end
  end

  def parse_string(str)
    line_num = -1
    records = []
    str.scan(/.{94}/).each do |line|
      line_num += 1
      records << process(line,line_num, records.last)
    end.compact
    records
  end

  def process(line, line_num, previous = nil)
    parent = previous
    record = nil

    record_types = valid_record_types(parent)
    while(record_types)
      record = parse_by_types(line, record_types)
      break if record || !parent
      parent = parent.parent
      record_types = valid_record_types(parent)
    end
    add_child(parent, record)
    record
  end

  def valid_record_types(parent)
    return DEFAULT_RECORD_TYPES unless parent && parent.respond_to?(:child_record_types)
    parent.child_record_types
  end

  def add_child(parent, child)
    return unless parent && child
    parent.children << child
    child.parent = parent
  end

  def parse_by_types(line, record_types)
    record_types.detect do |rt|
      record_type = Object.const_get(rt)
      if record_type.matcher =~ line
        return record_type.parse(line)
      end
    end
  end


end
