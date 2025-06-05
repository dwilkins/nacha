# coding: utf-8
# frozen_string_literal: true

require 'bigdecimal'
require 'nacha/numeric'
require 'nacha/aba_number'
require 'nacha/ach_date'

class Nacha::Field
  attr_accessor :inclusion, :position
  attr_accessor :name, :errors
  attr_reader :contents, :data, :input_data
  attr_reader :data_type
  attr_reader :validator
  attr_reader :justification
  attr_reader :fill_character
  attr_reader :output_conversion
  attr_reader :json_output

  def initialize(opts = {})
    @data_type = String
    @errors = []
    @name = 'Unknown'
    @justification = :ljust
    @fill_character = ' '
    @json_output = [:to_s]
    @output_conversion = [:to_s]
    opts.each do |k, v|
      setter = "#{k}="
      if respond_to?(setter)
        send(setter, v) unless v.nil?
      end
    end
  end

  # CXXX Constant
  #
  def contents=(val)
    @contents = val
    case @contents
    when /\AC(.*)\z/ # Constant
      @data = Regexp.last_match(1)
    when /Numeric/
      @data_type = Nacha::Numeric
      @justification = :rjust
      @json_output = [[:to_i]]
      @output_conversion = [:to_i]
      @fill_character = '0'
    when /.?TTTTAAAAC/
      @data_type = Nacha::AbaNumber
      @validator = :valid?
      @justification = :rjust
      @output_conversion = [:to_s]
      @fill_character = ' '
    when 'YYMMDD'
      @data_type = Nacha::AchDate
      @justification = :rjust
      @validator = :valid?
      @json_output = [[:iso8601]]
      @output_conversion = [:to_s]
      @fill_character = ' '
    when 'Alphameric'
      @data_type = String
      @justification = :ljust
      @output_conversion = [:to_s]
      @fill_character = ' '
    when /\$+\u00a2\u00a2/
      @data_type = Nacha::Numeric
      @justification = :rjust
      @json_output = [[:to_i], [:/, 100.0]]
      @output_conversion = [:to_i]
      @fill_character = '0'
    end
  end

  def data=(val)
    @data = @data_type.new(val)
    @input_data = val
  end

  def mandatory?
    @inclusion == 'M'
  end

  def required?
    @inclusion == 'R'
  end

  def optional?
    @inclusion == 'O'
  end

  def valid?
    @valid = inclusion && contents && position
    @valid &&= @data.send(@validator) if @validator && @data
    @valid
  end

  def add_error(err_string)
    errors << err_string
  end

  def self.unpack_str(definition = {})
    if definition[:contents] =~ /(Numeric|\$+\u00a2\u00a2)/
      'a'
    else
      'A'
    end + definition[:position].size.to_s
  end

  def to_ach
    str = to_s
    fill_char = @fill_character
    fill_char = ' ' unless str
    str ||= ''
    str.send(justification, position.count, fill_char)
  end

  def to_json_output
    if @json_output
      @json_output.reduce(@data) do |output, operation|
        output = output.send(*operation) if output
      end
    else
      to_s
    end
  end

  def human_name
    # @human_name ||= @name.to_s.gsub('_', ' ').capitalize
    @human_name ||= @name.to_s.split('_').map(&:capitalize).join(' ')
  end

  def to_html
    tooltip_text = "<span class=\"tooltiptext\" >#{human_name}</span>"
    field_classes = "nacha-field tooltip data-field-name=\"#{@name}\""
    ach_string = to_ach.gsub(' ', '&nbsp;')
    "<span class=\"#{field_classes}\" data-name=\"#{@name}\">#{ach_string}" +
      tooltip_text.to_s +
      "</span>"
  end

  def to_s
    @data.send(*output_conversion).to_s
  end

  def raw
    @data
  end
end
