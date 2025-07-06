require 'spec_helper'

RSpec.describe Nacha::Record::AdvFileControl, :nacha_record_type do
  let(:example_file_control_record) do
    '90000010000010000000200000000000000000000000000' \
      '00000000                                       '
  end

  it 'exists' do
    expect { described_class }.not_to raise_error
  end

  it 'generates a valid unpack string' do
    expect(described_class.unpack_str).to eq 'A1a6a6a8a10a20a20A23'
  end

  it 'generates a regexp matcher' do
    expect(described_class.matcher).to be_a Regexp
  end

  it 'recognizes input' do
    expect(described_class.matcher).to match example_file_control_record
  end

  describe 'parses a record' do
    let(:fcr) { described_class.parse(example_file_control_record) }
    let(:fcr_hash) do
      {
        nacha_record_type: 'adv_file_control',
        record_type_code: '9',
        batch_count: 1,
        block_count: 1,
        entry_addenda_count: 2,
        entry_hash: 0,
        reserved: '',
        total_credit_entry_dollar_amount_in_file: 0.0,
        total_debit_entry_dollar_amount_in_file: 0.0
      }
    end

    it 'record_type_code' do
      expect(fcr.record_type_code.to_ach).to eq '9'
    end

    it 'batch_count' do
      expect(fcr.batch_count.to_ach).to eq '000001'
    end

    it 'block_count' do
      expect(fcr.block_count.to_ach).to eq '000001'
    end

    it 'entry_addenda_count' do
      expect(fcr.entry_addenda_count.to_ach).to eq '00000002'
    end

    it 'entry_hash' do
      expect(fcr.entry_hash.to_ach).to eq '0000000000'
    end

    it 'total_debit_entry_dollar_amount_in_file' do
      expect(fcr.total_debit_entry_dollar_amount_in_file.to_ach)
        .to eq '00000000000000000000'
    end

    it 'total_credit_entry_dollar_amount_in_file' do
      expect(fcr.total_credit_entry_dollar_amount_in_file.to_ach)
        .to eq '00000000000000000000'
    end

    it 'converts to a hash' do
      expect(fcr.to_h.values).to include(*fcr_hash.values)
      expect(fcr.to_h.keys).to include(*fcr_hash.keys)
    end

    it 'converts to json' do
      expect(JSON.parse(fcr.to_json).values).to include(*fcr_hash.values)
      expect(JSON.parse(fcr.to_json).keys).to include(*fcr_hash.keys.collect(&:to_s))
    end
  end

  describe 'class generates json' do
    let(:class_json) { described_class.to_json }

    it 'is well formed' do
      expect(JSON.parse(class_json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(class_json)[described_class.record_type].keys).to include(
        'record_type_code',
        'batch_count',
        'block_count',
        'entry_addenda_count',
        'entry_hash',
        'total_debit_entry_dollar_amount_in_file',
        'total_credit_entry_dollar_amount_in_file',
        'reserved',
        'child_record_types',
        'klass'
      )
    end
  end
end
