# frozen_string_literal: true

require 'nacha'
require 'nacha/parser_context'
require 'nacha/ach_file'

# Nacha Parser - deal with figuring out what record type a line is
class Nacha::Parser
  DEFAULT_RECORD_TYPES = [
    'Nacha::Record::FileHeader',
    'Nacha::Record::AdvFileHeader',
    'Nacha::Record::Filler'
  ].freeze

  attr_reader :context

  def initialize
    @context = Nacha::ParserContext.new
  end

  def parse_file(file)
    @context.parser_started_at = Time.now.utc
    @context.file_name = file
    Nacha::AchFile.new(parse_string(file.read).records, file_name: file)
  end

  def detect_possible_record_types(line)
    Nacha.ach_record_types.filter_map do |record_type|
      record_type if record_type.matcher.match?(line)
    end
  end

  def parse_string(str)
    line_num = -1
    records = []
    @context.parser_started_at ||= Time.now.utc
    str.scan(/(.{0,94})[\r\n]*/).each do |line|
      line = line.compact.first.strip
      next if line.empty? || line.start_with?('#') # Skip empty lines and comments

      line_num += 1
      @context.line_number = line_num
      @context.line_length = line.length
      records << process(line, line_num, records.last)
    end.compact
    Nacha::AchFile.new(records)
  end

  def process(line, line_num, previous = nil)
    @context.line_errors = []
    parent = previous

    record_types = valid_record_types(parent)

    while record_types
      record = parse_first_by_types(line, record_types)
      break if record || !parent

      record_types = valid_record_types(parent.parent)
      parent = parent.parent
    end
    # Check all record types if no record was found
    # TODO: remove this fallback logic
    record ||= parse_first_by_types(line, Nacha.ach_record_types)

    if record
      record.line_number = line_num
      record.validate
      add_child(parent, record)
    end

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

  def parse_first_by_types(line, record_types)
    record_types.lazy.filter_map do |rt|
      record_type = rt.is_a?(Class) ? rt : Object.const_get(rt)
      record_type.parse(line) if record_type.matcher.match?(line)
    end.first
  end

  def parse_all_by_types(line, record_types)
    record_types.filter_map do |rt|
      record_type = rt.is_a?(Class) ? rt : Object.const_get(rt)
      record_type.parse(line) if record_type.matcher.match?(line)
    end
  end
end
