# coding: utf-8
require 'pry'
require 'bigdecimal'

class Nacha::Field

  attr_accessor :inclusion, :contents, :position
  attr_accessor :data
  attr_reader  :input_data
  attr_reader :data_type
  attr_reader :validator
  attr_reader :justification
  attr_reader :fill_character
  attr_reader :output_conversion
  attr_reader :json_output

  def initialize opts = {}
    @data_type = String
    @justification = :ljust
    @fill_character =  ' '.freeze
    @json_output = [:to_s]
    @output_conversion = [:to_s]
    opts.each do |k,v|
      setter = "#{k}="
      if(respond_to?(setter))
        send(setter, v) unless v.nil?
      end
    end
  end

  # CXXX Constant
  #
  def contents= val
    @contents = val
    case @contents
    when /\AC(.*)\z/  # Constant
      @data = $1
    when /Numeric/
      @data_type = Nacha::Numeric
      @justification = :rjust
      @json_output = [[:to_i]]
      @output_conversion = [:to_i]
      @fill_character = '0'
    when /bTTTTAAAAC/
      @data_type = Nacha::AbaNumber
      @validator = :valid?
      @justification = :rjust
      @output_conversion = [:to_s]
      @fill_character = ' '
    when 'YYMMDD'
      @data_type = Nacha::AchDate
      @justification = :rjust
      @validator = :valid?
      @json_output = [[:iso8601]]
      @output_conversion = [:to_s]
      @fill_character = ' '
    when 'Alphameric'
      @data_type = String
      @justification = :ljust
      @output_conversion = [:to_s]
      @fill_character = ' '
    when /\$+\¢\¢/
      @data_type = Nacha::Numeric
      @justification = :rjust
      @json_output = [[:to_i],[:/,100.0]]
      @output_conversion = [:to_i]
      @fill_character = '0'
    end
  end

  def data= val
    @data = @data_type.new(val)
    @input_data = val
  end

  def valid?
    @valid = inclusion && contents && position
    if(@validator && @data)
      @valid &&= @data.send(@validator)
    end
    @valid
  end

  def to_ach
    str = to_s
    fill_char = @fill_character
    fill_char = ' ' unless str
    str ||= ""
    str.send(justification,position.count, fill_char)
  end

  def to_json_output
    if(@json_output)
      @json_output.reduce(@data) { |output, operation|
        output = output.send(*operation)
      }
    else
      to_s
    end
  end

  def to_s
    @data.send(*output_conversion).to_s
  end

  def raw
    @data
  end

end
