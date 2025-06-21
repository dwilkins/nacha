# coding: utf-8
# frozen_string_literal: true

class Nacha::ParserContext
  attr_accessor :file_name
  attr_accessor :line_number
  attr_accessor :line_length
  attr_accessor :line_errors
  attr_accessor :parser_started_at
  attr_accessor :parser_ended_at # nil 'till the end of parsing
  attr_accessor :previous_record
  attr_reader :validated

  def initialize(opts = {})
    @file_name = opts[:file_name] || ''
    @line_number = opts[:line_number] || 0
    @line_length = opts[:line_length] || 0
    @current_line_errors = []
    @parser_started_at = Time.now
    @parser_ended_at = nil
    @previous_record = nil
    @validated = false
  end

  def validated?
    @validated ||= false
  end

  def valid?
    @valid ||= errors.empty?
  end

end
