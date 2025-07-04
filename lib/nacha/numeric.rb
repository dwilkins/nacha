# frozen_string_literal: true

class Nacha::Numeric
  def initialize(val = nil)
    self.value = val
  end

  def to_i
    return 0 if @value.nil?

    if @value.is_a?(String) && @value.match(/\A *\z/)
      @value # blank strings should return as blank
    else
      @value.to_i
    end
  end

  def value=(val)
    if val.is_a?(String)
      @value = val.dup
      if !val.strip.empty?
        @op_value = BigDecimal(val.strip)
        @value = val.dup
      else
        @op_value = BigDecimal('0')
      end
    elsif val.nil?
      @value = BigDecimal('0')
      @op_value = @value
    else
      @value = BigDecimal(val)
      @op_value = @value
    end
  end

  def to_s
    @value ? @value.to_i.to_s : nil
  end

  def respond_to_missing?(method_name, _include_private = false)
    @op_value.respond_to?(method_name)
  end

  # @op_value is the value for operations.   @value may still be a string
  # from the input data.   If an operation is attempted, then @op_value
  # should be checked to see if the operation is valid for it, not
  # necessarily the potentially string @value
  def method_missing(method_name, *args, &block)
    if @op_value.respond_to?(method_name)
      old_op_value = @op_value.dup
      # rubocop:disable GitlabSecurity/PublicSend
      if method_name.to_s.end_with?('!')
        @op_value.send(method_name, *args, &block)
        return_value = @op_value
      else
        return_value = @op_value.send(method_name, *args, &block)
      end
      # rubocop:enable GitlabSecurity/PublicSend

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
