require 'spec_helper'

RSpec.describe Nacha::Record::FileHeader, :nacha_record_type do
  let(:example_file_header_record) do
    '101 124000054 1240000540907021214A094101ZIONS FIRST NATIONAL BAZIONS ' \
      'FIRST NATIONAL BA       1'
  end

  it 'exists' do
    expect { described_class }.not_to raise_error
  end

  it 'generates a valid unpack string' do
    expect(described_class.unpack_str).to eq 'A1a2A10A10A6A4A1A3A2A1A23A23A8'
  end

  it 'generates a regexp matcher' do
    expect(described_class.matcher).to be_a Regexp
  end

  it 'generates a valid matcher',
    skip: 'The matcher regexp is complex and subject to change.' do
    expected_regexp = Regexp.new(
      '\A1.................................094101' \
        '......................................................\z'
    )
    expect(described_class.matcher).to eq(expected_regexp)
  end

  it 'recognizes input' do
    expect(described_class.matcher).to match example_file_header_record
  end

  describe 'parses a record' do
    let(:fhr) { described_class.parse(example_file_header_record) }

    it 'record_type_code' do
      expect(fhr.record_type_code.to_ach).to eq '1'
    end

    it 'priority_code' do
      expect(fhr.priority_code.to_ach).to eq '01'
    end

    it 'immediate_destination' do
      expect(fhr.immediate_destination.to_ach).to eq ' 124000054'
    end

    it 'immediate_origin' do
      expect(fhr.immediate_origin.to_ach).to eq ' 124000054'
    end

    it 'file_creation_date' do
      expect(fhr.file_creation_date.to_ach).to eq '090702'
    end

    it 'file_creation_time' do
      expect(fhr.file_creation_time.to_ach).to eq '1214'
    end

    it 'file_id_modifier' do
      expect(fhr.file_id_modifier.to_ach).to eq 'A'
    end

    it 'record_size' do
      expect(fhr.record_size.to_ach).to eq '094'
    end

    it 'blocking_factor' do
      expect(fhr.blocking_factor.to_ach).to eq '10'
    end

    it 'format_code' do
      expect(fhr.format_code.to_ach).to eq '1'
    end

    it 'immediate_destination_name' do
      expect(fhr.immediate_destination_name.to_ach).to eq 'ZIONS FIRST NATIONAL BA'
    end

    it 'immediate_origin_name' do
      expect(fhr.immediate_origin_name.to_ach).to eq 'ZIONS FIRST NATIONAL BA'
    end

    it 'reference_code' do
      expect(fhr.reference_code.to_ach).to eq '       1'
    end

    it 'child_record_types' do
      expect(fhr.child_record_types.count).to eq 2
    end
  end

  describe 'generates json' do
    let(:fhr_json) { described_class.parse(example_file_header_record).to_json }

    it 'is well formed' do
      expect(JSON.parse(fhr_json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(fhr_json).keys).to include(
        'record_type_code',
        'priority_code',
        'immediate_destination',
        'immediate_origin',
        'file_creation_date',
        'file_creation_time',
        'file_id_modifier',
        'record_size',
        'blocking_factor',
        'format_code',
        'immediate_destination_name',
        'immediate_origin_name',
        'reference_code'
      )
    end
  end
end
