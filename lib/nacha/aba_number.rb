# frozen_string_literal: true

class Nacha::AbaNumber
  attr_reader :routing_number
  attr_reader :aba_number

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
    @valid ||= (@routing_number.length == 9 && compute_check_digit == @routing_number.chars[8])
  end

  def to_s(with_checkdigit = true)
    if with_checkdigit
      @routing_number
    else
      @routing_number[0..7]
    end
  end
end
