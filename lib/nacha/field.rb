# coding: utf-8
# frozen_string_literal: true

require 'bigdecimal'
require 'nacha/numeric'
require 'nacha/aba_number'
require 'nacha/ach_date'

class Nacha::Field
  attr_accessor :inclusion, :position, :name, :errors
  attr_reader :contents, :data, :input_data, :data_type, :validator,
              :justification, :fill_character, :output_conversion, :json_output

  def self.unpack_str(definition = {})
    if definition[:contents].match?(/(Numeric|\$+\u00a2\u00a2)/)
      'a'
    else
      'A'
    end + definition[:position].size.to_s
  end

  def initialize(opts = {})
    @data_type = String
    @errors = []
    @name = 'Unknown'
    @justification = :ljust
    @fill_character = ' '
    @json_output = [:to_s]
    @output_conversion = [:to_s]
    @validated = false
    @data_assigned = false
    opts.each do |k, v|
      setter = "#{k}="
      public_send(setter, v) if respond_to?(setter) && !v.nil?
    end
  end

  # CXXX Constant
  #
  def contents=(val)
    @contents = val
    case @contents
    when /\$.*¢*/
      @data_type = Nacha::Numeric
      @justification = :rjust
      cents = 10**@contents.count('¢')
      @json_output = [[:to_i], [:/, cents]]
      @output_conversion = [:to_i]
      @fill_character = '0'
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
    when /\AC(.*)\z/ # Constant
      @data = Regexp.last_match(1)
    end
  end

  def data=(val)
    @validated = false
    @data_assigned = true
    @errors = []
    @data = @data_type.new(val)
    @input_data = val
  rescue StandardError => e
    add_error("Invalid data for #{@name}: \"#{val.inspect}\"")
    add_error("Error: #{e.message}")
    @data = String.new(val.to_s)
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

  def validate
    return if @validated

    validate_definition_attributes
    validate_data_presence
    validate_numeric_format
    run_custom_validator

    @validated = true
  end

  def valid?
    validate
    errors.empty?
  end

  def add_error(err_string)
    errors << err_string
  end

  def to_ach
    str = to_s
    fill_char = @fill_character
    fill_char = ' ' unless str
    str ||= ''
    str.public_send(justification, position.count, fill_char)
  end

  def to_json_output
    if @json_output
      @json_output.reduce(@data) do |memo, operation|
        memo&.public_send(*operation)
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
    tooltip_text = "<span class=\"tooltiptext\" >#{human_name} #{errors.join(' ')}</span>"
    field_classes = ["nacha-field tooltip"]
    field_classes += ['mandatory'] if mandatory?
    field_classes += ['required'] if required?
    field_classes += ['optional'] if optional?
    field_classes += ['error'] if errors.any?

    ach_string = to_ach.gsub(' ', '&nbsp;')
    "<span data-field-name=\"#{@name}\" contentEditable=true " \
      "class=\"#{field_classes.join(' ')}\" data-name=\"#{@name}\">" \
      "#{ach_string}#{tooltip_text}</span>"
  end

  def to_s
    @data.public_send(*output_conversion).to_s
  end

  def raw
    @data
  end

  private

  def validate_definition_attributes
    add_error("'inclusion' must be present for a field definition.") unless @inclusion
    add_error("'position' must be present for a field definition.") unless @position
    add_error("'contents' must be present for a field definition.") unless @contents
  end

  def validate_data_presence
    return unless @data_assigned && (mandatory? || required?)
    return unless @input_data.nil? || @input_data.to_s.empty?
    return if @contents.match?(/\AC(  *)\z/)

    add_error("'#{human_name}' is a required field and cannot be blank.")
  end

  def validate_numeric_format
    return unless @data_type == Nacha::Numeric && @input_data.to_s.strip.match(/\D/)

    add_error("Invalid characters in numeric field '#{human_name}'. " \
              "Got '#{@input_data}'.")
  end

  def run_custom_validator
    return unless @validator && @data.is_a?(@data_type)

    is_valid = @data.public_send(@validator)

    @data.errors.each { |e| add_error(e) } if @data.respond_to?(:errors) && @data.errors&.any?

    return if is_valid || errors.any?

    add_error("'#{human_name}' is invalid. Got '#{@input_data}'.")
  end
end
