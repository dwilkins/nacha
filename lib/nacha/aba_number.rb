# frozen_string_literal: true

require "nacha/has_errors"

# Validates and formats an ABA routing number.
class Nacha::AbaNumber
  attr_reader :routing_number, :aba_number

  include Nacha::HasErrors

  def initialize(routing_number)
    @errors = []
    self.routing_number = routing_number
  end

  # :reek:FeatureEnvy
  def compute_check_digit
    digit_array = @routing_number.ljust(8, '0').chars.collect(&:to_i)
    sum = (3 * (digit_array[0] + digit_array[3] + digit_array[6])) +
      (7 * (digit_array[1] + digit_array[4] + digit_array[7])) +
      (digit_array[2] + digit_array[5])

    intermediate = (sum % 10)
    intermediate.zero? ? '0' : (10 - intermediate).to_s
  end

  def routing_number=(val)
    @valid = nil
    @errors&.clear
    @routing_number = val.to_s.strip
  end

  def add_check_digit
    @routing_number = @routing_number[0..7] + compute_check_digit
  end

  def check_digit
    check = @routing_number[8]
    return unless @routing_number.length == 9 && compute_check_digit == check

    check
  end

  def valid?
    @valid ||= if valid_routing_number_length?
                 if @routing_number.length == 9
                   valid_check_digit?
                 else # 8 digits is valid
                   true
                 end
               else
                 false
               end
  end

  def valid_routing_number_length?
    actual_length = @routing_number.length

    if [9, 10].include?(actual_length)
      true
    else
      add_error("Routing number must be 8 or 9 digits long, but was " \
        "#{actual_length} digits long.")
      false
    end
  end

  def valid_check_digit?
    check = @routing_number[8]
    if compute_check_digit != check
      add_error("Incorrect Check Digit \"#{check}\" should be " \
        "\"#{compute_check_digit}\"")
      false
    else
      true
    end
  end

  def to_s
    @routing_number
  end

  def to_s_base
    @routing_number[0..7]
  end
end
