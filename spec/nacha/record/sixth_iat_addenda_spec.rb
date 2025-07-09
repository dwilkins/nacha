require 'spec_helper'

RSpec.describe Nacha::Record::SixthIatAddenda, :nacha_record_type do
  it 'exists' do
    expect { described_class }.not_to raise_error
  end

  describe 'class generates json' do
    let(:class_json) { described_class.to_json }

    it 'is well formed' do
      expect(JSON.parse(class_json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(class_json)[described_class.record_type].keys).to include(
        'record_type_code',
        'addenda_type_code',
        'receiver_identification_number',
        'receiver_street_address',
        'reserved',
        'entry_detail_sequence_number',
        'child_record_types',
        'klass'
      )
    end
  end

  describe 'instance generates json' do
    let(:json) { described_class.new.to_json }

    it 'is well formed' do
      expect(JSON.parse(json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(json).keys).to include(
        'metadata',
        'nacha_record_type',
        'record_type_code',
        'addenda_type_code',
        'receiver_identification_number',
        'receiver_street_address',
        'reserved',
        'entry_detail_sequence_number'
      )
    end
  end
end
