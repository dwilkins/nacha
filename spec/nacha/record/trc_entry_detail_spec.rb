require 'spec_helper'
require 'nacha/formatter'

RSpec.describe Nacha::Record::TrcEntryDetail, :nacha_record_type do
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
        'transaction_code',
        'receiving_dfi_identification',
        'dfi_account_number',
        'amount',
        'check_serial_number',
        'process_control_field',
        'item_research_number',
        'item_type_indicator',
        'addenda_record_indicator',
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
        'transaction_code',
        'receiving_dfi_identification',
        'dfi_account_number',
        'amount',
        'check_serial_number',
        'process_control_field',
        'item_research_number',
        'item_type_indicator',
        'addenda_record_indicator',
        'trace_number'
      )
    end
  end
end
