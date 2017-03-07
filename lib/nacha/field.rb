require 'pry'


class Nacha::Field

  attr_accessor :inclusion, :contents, :position
  attr_accessor :data
  attr_reader :data_type
  attr_reader :justification
  attr_reader :fill_character

  def initialize opts = {}
    @data_type = String
    @justification = :ljust
    @fill_character =  ' '.freeze
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
      @data_type = BigDecimal
      @justification = :rjust
      @fill_character = '0'
    end
  end

  def justification= val
  end


  def valid?
    inclusion && contents && position
  end

  def to_ach
    @data.send(justification,position.count, fill_character)
  end

  def raw
    @data
  end

end
