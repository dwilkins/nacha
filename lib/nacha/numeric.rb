class Nacha::Numeric
  attr_accessor :value
  def initialize val = nil
    if(val.is_a?(String))
      val.strip!
      if(val.length > 0)
        @value = BigDecimal.new(val)
      end
    else
      @value = BigDecimal.new(val)
    end
  end

  def to_i
    @value ? @value.to_i : self
  end

  def to_s
    @value ? @value.to_s : nil
  end
end
