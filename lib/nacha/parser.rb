require 'nacha'

class Nacha::Parser

  def initialize
    loader = Nacha::Loader.instance
    reset!
  end

  def reset!
    @valid_record_types = [ 'Nacha::Record::FileHeader' ]
  end

  def parse_file(file)
    parent = nil
    records = []
    File.foreach(file).with_index do |line, line_num|
      records << process(line,line_num, records.last)
      parent = records.last if parent.is_a?()
    end
  end

  def parse_string(str)
    line_num = -1
    str.scan(/.{94}/).map do |line|
      line_num += 1
      process(line,line_num)
    end.compact
  end

  def process(line, line_num, previous = nil)
    record_type = nil
    @valid_record_types.detect do |rt|
      record_type = Object.const_get(rt)
      if record_type.matcher =~ line
        puts "It's an #{rt}"
        return(record_type.parse line)
      end
    end
  end

end
