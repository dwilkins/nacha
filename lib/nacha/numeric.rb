# frozen_string_literal: true
class Nacha::Numeric
  def initialize val = nil
    self.value = val
  end

  def to_i
    @op_value ? @op_value.to_i : 0
  end

  def ==(other)
    if other.is_a?(Nacha::Numeric)
      # Compare internal BigDecimal values if @op_value is not nil
      # and other object's @op_value is not nil
      return false if @op_value.nil? || other.instance_variable_get(:@op_value).nil?
      @op_value == other.instance_variable_get(:@op_value)
    elsif other.is_a?(Numeric)
      # Compare internal BigDecimal value with other Numeric type
      # Handles cases like Nacha::Numeric.new(10) == 10
      return false if @op_value.nil?
      @op_value == other
    else
      # If other is not Nacha::Numeric or Numeric, delegate to @op_value's ==
      # or return false if @op_value is nil.
      # This maintains behavior for other types if BigDecimal itself can handle them.
      @op_value ? @op_value == other : false
    end
  end

  def value=(val)
    if val.is_a?(String)
      stripped_val = val.strip
      if stripped_val.empty?
        @value = nil
        @op_value = BigDecimal(0)
      else
        # Attempt to convert to BigDecimal, handle potential errors
        begin
          big_decimal_val = BigDecimal(stripped_val)
          @value = big_decimal_val
          @op_value = big_decimal_val
        rescue ArgumentError # Catch specific error for non-numeric strings
          @value = nil
          @op_value = BigDecimal(0)
        end
      end
    else # val is not a String (e.g., Integer, Float, Nil, other objects)
      begin
        # For Floats, convert to string first to ensure precision for BigDecimal
        # For nil, BigDecimal(nil.to_s) would be BigDecimal(''), which is invalid.
        # BigDecimal() or BigDecimal(nil) directly causes TypeError.
        if val.is_a?(Float)
          big_decimal_val = BigDecimal(val.to_s)
        elsif val.nil?
          # Explicitly handle nil to avoid TypeError with BigDecimal(nil)
          # and ensure consistent behavior with empty/non-numeric strings.
          @value = nil
          @op_value = BigDecimal(0)
          return # Exit early after handling nil
        else
          big_decimal_val = BigDecimal(val)
        end
        @value = big_decimal_val
        @op_value = big_decimal_val
      rescue ArgumentError, TypeError # Catch ArgumentError (e.g. BigDecimal("non-numeric")) or TypeError (e.g. BigDecimal(object))
        @value = nil
        @op_value = BigDecimal(0)
      end
    end
  end

  def to_s
    @value ? @value.to_s : nil
  end

  def respond_to_missing?(method_name, include_private = false)
    # If @value is nil, it represents an undefined or invalid numeric state.
    # In such a case, it arguably shouldn't respond to arithmetic methods.
    return false if @value.nil? && ![:to_s, :to_i].include?(method_name.to_sym) # Allow to_s, to_i

    # Otherwise, delegate to @op_value
    @op_value&.respond_to?(method_name) || super
  end

  # @op_value is the value for operations.   @value may still be a string
  # from the input data.   If an operation is attempted, then @op_value
  # should be checked to see if the operation is valid for it, not
  # necessarily the potentially string @value
  def method_missing(method_name, *args, &block)
    # Gracefully handle nil @op_value
    unless @op_value&.respond_to?(method_name)
      return super
    end

    # Use public_send for safety
    is_bang_method = /!\z/.match?(method_name.to_s)

    if is_bang_method
      # Bang methods modify @op_value in place
      @op_value.public_send(method_name, *args, &block)
      # Update @value to reflect the in-place modification of @op_value
      @value = @op_value
      # Bang methods on BigDecimal often return self, so returning @op_value (which is self) is appropriate.
      # Or, if they return a new value (though less common for bang methods on BigDecimal),
      # @op_value is already that new value.
      return @op_value
    else
      # Non-bang methods return a new value
      result = @op_value.public_send(method_name, *args, &block)

      # If the result is a BigDecimal, update @value and @op_value
      # This allows Nacha::Numeric to continue wrapping the result of operations like +, -, etc.
      # Operations like <, >, == will return true/false, and those will be returned directly.
      if result.is_a?(BigDecimal)
        @value = result
        @op_value = result
      end
      # Return the actual result of the operation
      return result
    end
  end
end
