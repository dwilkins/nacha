require 'spec_helper'
require 'nacha/formatter'

RSpec.describe Nacha::Record::BatchControl, :nacha_record_type do
  let(:example_batch_control_record) do
    #         1         2         3         4         5         6         7         8         9
    #1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
    '822000000200248602040000000000000000002001002870327243                         124000050000001'
  end

  it 'exists' do
    expect { described_class }.not_to raise_error
  end

  it 'generates a valid unpack string' do
    expect(described_class.unpack_str).to eq 'A1a3a6a10a12a12A10A19A6A8a7'
  end

  it 'generates a regexp matcher' do
    expect(described_class.matcher).to be_a Regexp
  end

  it 'recognizes input' do
    expect(described_class.matcher).to match example_batch_control_record
  end

  describe 'parses a record' do
    let(:bcr) { described_class.parse(example_batch_control_record) }

    it 'record_type_code' do
      expect(bcr.record_type_code.to_ach).to eq '8'
    end

    it 'service_class_code' do
      expect(bcr.service_class_code.to_ach).to eq '220'
    end

    it 'entry_addenda_count' do
      expect(bcr.entry_addenda_count.to_ach).to eq '000002'
    end

    it 'entry_hash' do
      expect(bcr.entry_hash.to_ach).to eq '0024860204'
    end

    it 'total_debit_entry_dollar_amount' do
      expect(bcr.total_debit_entry_dollar_amount.to_ach).to eq '000000000000'
    end

    it 'total_credit_entry_dollar_amount' do
      expect(bcr.total_credit_entry_dollar_amount.to_ach).to eq '000000200100'
    end

    it 'company_identification' do
      expect(bcr.company_identification.to_ach).to eq '2870327243'
    end

    it 'message_authentication_code' do
      expect(bcr.message_authentication_code.to_ach).to eq '                   '
    end

    it 'originating_dfi_identification' do
      expect(bcr.originating_dfi_identification.to_ach).to eq '12400005'
    end

    it 'batch_number' do
      expect(bcr.batch_number.to_ach).to eq '0000001'
    end
  end

  describe 'class generates json' do
    let(:class_json) { JSON.pretty_generate(described_class.to_h) }

    it 'is well formed' do
      expect(JSON.parse(class_json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(class_json)[described_class.record_type].keys).to include(
        'record_type_code',
        'service_class_code',
        'entry_addenda_count',
        'entry_hash',
        'total_debit_entry_dollar_amount',
        'total_credit_entry_dollar_amount',
        'company_identification',
        'message_authentication_code',
        'originating_dfi_identification',
        'batch_number',
        'child_record_types',
        'klass'
      )
    end
  end

  describe 'instance generates json' do
    let(:record) { described_class.parse(example_batch_control_record) }
    let(:formatter) { Nacha::Formatter::JsonFormatter.new(Nacha::AchFile.new([record])) }
    let(:record_json) { JSON.parse(formatter.format)['records'].first }

    it 'is well formed' do
      expect(record_json).to be_a Hash
    end

    it 'has the right keys' do
      expect(record_json.keys).to include(
        'metadata',
        'nacha_record_type',
        'record_type_code',
        'service_class_code',
        'entry_addenda_count',
        'entry_hash',
        'total_debit_entry_dollar_amount',
        'total_credit_entry_dollar_amount',
        'company_identification',
        'message_authentication_code',
        'originating_dfi_identification',
        'batch_number'
      )
    end
  end
end
