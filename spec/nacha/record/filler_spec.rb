# coding: utf-8
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nacha::Record::Filler, :nacha_record_type do
  subject(:record_class) { described_class }

  let(:example_filler_record) { '9' * 94 }

  it 'exists' do
    expect { described_class }.not_to raise_error
  end

  it 'generates a valid unpack string' do
    expect(described_class.unpack_str).to eq 'A1A93'
  end

  it 'generates a regexp matcher' do
    expect(described_class.matcher).to be_a Regexp
  end

  it 'is valid with a valid filler record' do
    filler_record = record_class.parse(example_filler_record)
    expect(filler_record).to be_valid
  end

  it 'is invalid with an invalid filler record' do
    invalid_filler_record = '92345678901234567890123456789012345678901234567890' \
      '12345678901234567890123456789012345678901234'
    filler_record = record_class.parse(invalid_filler_record)
    expect(filler_record).not_to be_valid, filler_record.errors&.join(', ').to_s
    expect(filler_record.class).to eq described_class
    expect(filler_record.errors).not_to be_empty
  end

  describe 'class generates json' do
    let(:class_json) { described_class.to_json }

    it 'is well formed' do
      expect(JSON.parse(class_json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(class_json)[described_class.record_type].keys).to include(
        'record_type_code',
        'filler',
        'child_record_types',
        'klass'
      )
    end
  end

  describe 'instance generates json' do
    let(:record_json) { described_class.parse(example_filler_record).to_json }

    it 'is well formed' do
      expect(JSON.parse(record_json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(record_json).keys).to include(
        'metadata',
        'nacha_record_type',
        'record_type_code',
        'filler'
      )
    end
  end
end
