# frozen_string_literal: true
class Nacha::Numeric
  attr_accessor :value
  def initialize(val = nil)
    self.value = val
  end

  def to_i
    if @value
      if @value.is_a?(String) && @value.match(/ */)
        self
      else
        @value.to_i
      end
    else
      self
    end
  end

  def value=(val)
    if val.is_a?(String)
      @value = val.dup
      if !val.strip.empty?
        @value = BigDecimal(val.strip)
        @op_value = @value
      else
        @op_value = BigDecimal(0)
      end
    else
      @value = BigDecimal(val)
      @op_value = @value
    end
    @value
  end

  def to_s
    @value ? @value.to_s : nil
  end

  def respond_to?(method_name, include_private = false)
    puts "In respond_to? #{method_name}"
    @op_value.respond_to? method_name
  end

  # @op_value is the value for operations.   @value may still be a string
  # from the input data.   If an operation is attempted, then @op_value
  # should be checked to see if the operation is valid for it, not
  # necessarily the potentially string @value
  def method_missing(method_name, *args, &block)
    puts "In method_missing for #{method_name} value_class = #{@value.class}, op_value_class = #{@op_value.class}"
    if @op_value.respond_to? method_name
      old_op_value = @op_value.dup
      if /!\z/.match?(method_name.to_s)
        @op_value.send(method_name, *args, &block)
        return_value = @op_value
      else
        return_value = @op_value.send(method_name, *args, &block)
      end
      if old_op_value != return_value
        @value = return_value
        @op_value = return_value
      end
      @value
    else
      super
    end
  end
end
