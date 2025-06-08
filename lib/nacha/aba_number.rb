# frozen_string_literal: true

require "nacha/has_errors"

class Nacha::AbaNumber
  attr_reader :routing_number
  attr_reader :aba_number

  include HasErrors

  def initialize(routing_number)
    self.routing_number = routing_number
  end

  def compute_check_digit
    n = @routing_number.to_s.strip.ljust(8, '0').chars.collect(&:to_i)
    sum = (3 * (n[0] + n[3] + n[6])) +
      (7 * (n[1] + n[4] + n[7])) +
      (n[2] + n[5])
    intermediate = (sum % 10)
    intermediate.zero? ? '0' : (10 - intermediate).to_s
  end

  def routing_number=(val)
    @valid = nil
    @routing_number = val.strip
  end

  def add_check_digit
    @routing_number = @routing_number[0..7] + compute_check_digit
  end

  def check_digit
    @routing_number.chars[8] if @routing_number.length == 9 && compute_check_digit == @routing_number.chars[8]
  end

  def valid?
    @valid ||= valid_routing_number_length? && valid_check_digit?
  end

  def valid_routing_number_length?
    if @routing_number.length != 9
      add_error("Routing number must be 9 digits long, but was #{@routing_number.length} digits long.")
      false
    else
      true
    end
  end

  def valid_check_digit?
    if compute_check_digit != @routing_number.chars[8]
      add_error("Incorrect Check Digit \"#{@routing_number.chars[8]}\" should be \"#{ compute_check_digit }\" ")
      false
    else
      true
    end
  end

  def to_s(with_checkdigit = true)
    if with_checkdigit
      @routing_number
    else
      @routing_number[0..7]
    end
  end
end
