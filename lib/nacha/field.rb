# coding: utf-8
require 'pry'
require 'bigdecimal'
require 'nacha/numeric'
require 'nacha/aba_number'
require 'nacha/ach_date'

class Nacha::Field

  attr_accessor :inclusion, :contents, :position
  attr_accessor :data, :name, :errors
  attr_reader  :input_data
  attr_reader :data_type
  attr_reader :validator
  attr_reader :justification
  attr_reader :fill_character
  attr_reader :output_conversion
  attr_reader :json_output

  def initialize opts = {}
    @data_type = String
    @errors = []
    @name = 'Unknown'.freeze
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
      @fill_character = '0'.freeze
    when /.?TTTTAAAAC/
      @data_type = Nacha::AbaNumber
      @validator = :valid?
      @justification = :rjust
      @output_conversion = [:to_s]
      @fill_character = ' '.freeze
    when 'YYMMDD'
      @data_type = Nacha::AchDate
      @justification = :rjust
      @validator = :valid?
      @json_output = [[:iso8601]]
      @output_conversion = [:to_s]
      @fill_character = ' '.freeze
    when 'Alphameric'
      @data_type = String
      @justification = :ljust
      @output_conversion = [:to_s]
      @fill_character = ' '.freeze
    when /\$+\¢\¢/
      @data_type = Nacha::Numeric
      @justification = :rjust
      @json_output = [[:to_i],[:/,100.0]]
      @output_conversion = [:to_i]
      @fill_character = '0'.freeze
    end
  end

  def data= val
    @data = @data_type.new(val)
    @input_data = val
  end

  def mandatory?
    @inclusion == 'M'.freeze
  end

  def required?
    @inclusion == 'R'.freeze
  end

  def optional?
    @inclusion == 'O'.freeze
  end

  def valid?
    @valid = inclusion && contents && position
    if(@validator && @data)
      @valid &&= @data.send(@validator)
    end
    @valid
  end

  def add_error err_string
    errors << err_string
  end

  def self.unpack_str(definition = {  })
    if(definition[:contents] =~ /(Numeric|\$+\¢\¢)/)
      'a'.freeze
    else
      'A'.freeze
    end + definition[:position].size.to_s
  end

  def to_ach
    str = to_s
    fill_char = @fill_character
    fill_char = ' '.freeze unless str
    str ||= ''.freeze
    str.send(justification,position.count, fill_char)
  end

  def to_json_output
    if(@json_output)
      @json_output.reduce(@data) { |output, operation|
        output = output.send(*operation) if output
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
