# frozen_string_literal: true

require 'nacha'
require 'nacha/parser_context'

class Nacha::Parser
  DEFAULT_RECORD_TYPES = ['Nacha::Record::FileHeader'].freeze

  attr_reader :context

  def initialize
    @context = Nacha::ParserContext.new
    reset!
  end

  def reset!; end

  def parse_file(file)
    @context.parser_started_at = Time.now
    @context.file_name = file
    parse_string(file.read)
  end

  def parse_string(str)
    line_num = -1
    records = []
    @context.parser_started_at ||= Time.now
    str.scan(/(.{94}|(\A[^\n]+))/).each do |line|
      line = line.first.strip
      line_num += 1
      @context.line_number = line_num
      @context.line_length = line.length
      records << process(line, line_num, records.last)
    end.compact
    records
  end

  def process(line, line_num, previous = nil)
    @context.line_errors = []
    parent = previous
    record = nil

    record_types = valid_record_types(parent)
    while record_types
      record = parse_by_types(line, record_types)
      break if record || !parent
      record.validate if record
      parent = parent.parent
      record_types = valid_record_types(parent)
    end
    record.line_number = line_num if record
    add_child(parent, record)
    record
  end

  def valid_record_types(parent)
    return DEFAULT_RECORD_TYPES unless parent && parent.respond_to?(:child_record_types)

    parent.child_record_types
  end

  def add_child(parent, child)
    return unless parent && child

    parent.children << child
    child.parent = parent
  end

  def parse_by_types(line, record_types)
    record_types.detect do |rt|
      record_type = Object.const_get(rt)
      record = record_type.parse(line) if record_type.matcher =~ line
      return record if record
    end
  end
end
