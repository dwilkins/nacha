require 'spec_helper'
require 'nacha/formatter'

RSpec.describe Nacha::Record::ShrAddenda, :nacha_record_type do
  it 'exists' do
    expect { described_class }.not_to raise_error
  end

  describe 'class generates json' do
    let(:class_json) { JSON.pretty_generate(described_class.to_h) }

    it 'is well formed' do
      expect(JSON.parse(class_json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(class_json)[described_class.record_type].keys).to include(
        'record_type_code',
        'addenda_type_code',
        'reference_information_1',
        'reference_information_2',
        'terminal_identification_code',
        'transaction_serial_number',
        'transaction_date',
        'authorization_code_or_card_expiration_date',
        'terminal_location',
        'terminal_city',
        'terminal_state',
        'trace_number',
        'child_record_types',
        'klass'
      )
    end
  end

  describe 'instance generates json' do
    let(:record) { described_class.new }
    let(:formatter) { Nacha::Formatter::JsonFormatter.new([record]) }
    let(:json) { JSON.parse(formatter.format)['records'].first }

    it 'is well formed' do
      expect(json).to be_a Hash
    end

    it 'has the right keys' do
      expect(json.keys).to include(
        'metadata',
        'nacha_record_type',
        'record_type_code',
        'addenda_type_code',
        'reference_information_1',
        'reference_information_2',
        'terminal_identification_code',
        'transaction_serial_number',
        'transaction_date',
        'authorization_code_or_card_expiration_date',
        'terminal_location',
        'terminal_city',
        'terminal_state',
        'trace_number'
      )
    end
  end
end
