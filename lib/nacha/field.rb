require 'pry'
require 'bigdecimal'

class Nacha::Field

  attr_accessor :inclusion, :contents, :position
  attr_accessor :data
  attr_reader :data_type
  attr_reader :justification
  attr_reader :fill_character
  attr_reader :output_conversion

  def initialize opts = {}
    @data_type = String
    @justification = :ljust
    @fill_character =  ' '.freeze
    @output_conversion = [:to_s]
    opts.each do |k,v|
      setter = "#{k}="
      if(respond_to?(setter))
        send(setter, v) unless v.nil?
      end
    end
  end

  def unpack_str
    "A#{position.count}"
  end

  # CXXX Constant
  #
  def contents= val
    @contents = val
    case @contents
    when /\AC(.*)\z/
      @data = $1
    when /Numeric/
      @data_type = ::BigDecimal
      @justification = :rjust
      @output_conversion = [:to_i]
      @fill_character = '0'
    when /bTTTTAAAAC/
      @data_type = AbaNumber
      @justification = :rjust
      @output_conversion = [:to_i]
      @fill_character = ' '
    end
  end

  def data= val
    @data = @data_type.new(val)
  end

  def valid?
    inclusion && contents && position
  end

  def to_ach
    to_s.send(justification,position.count, fill_character)
  end

  def to_s
    @data.send(*output_conversion).to_s
  end

  def raw
    @data
  end

end
