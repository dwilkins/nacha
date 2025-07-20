require 'spec_helper'
require 'nacha/formatter'

RSpec.describe 'Nacha::Record::AdvBatchControl', :nacha_record_type do
  subject(:record_class) { Nacha::Record::AdvBatchControl }

  let(:example_adv_batch_control_record) do
    #         1         2         3         4         5         6         7         8         9
    #1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
    '822000000200248602040000000000000000002001002870327243                         124000050000001'
  end

  it 'exists' do
    expect { record_class }.not_to raise_error
  end

  it 'generates a valid unpack string' do
    expect(record_class.unpack_str).to eq 'A1a3a6a10a20a20A19A8a7'
  end

  it 'generates a regexp matcher' do
    expect(record_class.matcher).to be_a Regexp
  end

  describe 'valid record' do
    let(:abcr) { record_class.parse(example_adv_batch_control_record) }

    it 'has a record_type_code' do
      expect(abcr.record_type_code.to_ach).to eq '8'
    end

    it 'is valid' do
      expect(abcr).to be_valid
    end
  end

  describe 'invalid record' do
    let(:example_adv_batch_control_record) do
      #         1         2         3         4         5         6         7         8         9
      #1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
      '8999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999991'
    end

    let(:abcr) { Nacha::Record::AdvBatchControl.parse(example_adv_batch_control_record) }

    it 'has a record_type_code' do
      expect(abcr.record_type_code.to_ach).to eq '8'
    end

    it 'is valid' do
      expect(abcr).not_to be_valid, abcr.errors&.join(', ').to_s
      expect(abcr.class).to eq Nacha::Record::AdvBatchControl
      expect(abcr.errors).not_to be_empty
    end
  end

  describe 'class generates json' do
    let(:class_json) { JSON.pretty_generate(record_class.to_h) }

    it 'is well formed' do
      expect(JSON.parse(class_json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(class_json)[record_class.record_type].keys).to include(
        'record_type_code',
        'service_class_code',
        'entry_addenda_count',
        'entry_hash',
        'total_debit_entry_dollar_amount',
        'total_credit_entry_dollar_amount',
        'ach_operator_data',
        'originating_dfi_identification',
        'batch_number',
        'child_record_types',
        'klass'
      )
    end
  end

  describe 'instance generates json' do
    let(:record) { record_class.parse(example_adv_batch_control_record) }
    let(:formatter) { Nacha::Formatter::JsonFormatter.new([record]) }
    let(:abcr_json) { JSON.parse(formatter.format)['records'].first }

    it 'is well formed' do
      expect(abcr_json).to be_a Hash
    end

    it 'has the right keys' do
      expect(abcr_json.keys).to include(
        'metadata',
        'nacha_record_type',
        'record_type_code',
        'service_class_code',
        'entry_addenda_count',
        'entry_hash',
        'total_debit_entry_dollar_amount',
        'total_credit_entry_dollar_amount',
        'ach_operator_data',
        'originating_dfi_identification',
        'batch_number'
      )
    end
  end
end
