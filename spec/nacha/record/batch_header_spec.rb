require 'spec_helper'
require 'nacha/formatter'

RSpec.describe Nacha::Record::BatchHeader, :nacha_record_type do
  let(:example_batch_header_record) do
    '5220DHI PAYROLL                         2870327243PPDDHIPAYROLL' \
      '090702081205   1124000050000001'
  end

  let(:example_batch_header_record_settlement_date) do
    '5220DHI PAYROLL                         2870327243PPDDHIPAYROLL' \
      '0907020812051001124000050000001'
  end

  it 'has a factory' do
    bh = build(:batch_header)
    pbh = build(:ppd_batch_header)
    expect(bh).to be_a described_class
    expect(pbh).to be_a described_class
    expect(bh.standard_entry_class_code.to_s).to eq('PPD')
    expect(pbh.standard_entry_class_code.to_s).to eq('PPD')
  end

  it 'exists' do
    expect { described_class }.not_to raise_error
  end

  it 'generates a valid unpack string' do
    expect(described_class.unpack_str).to eq 'A1a3A16A20A10A3A10A6A6a3A1A8a7'
  end

  it 'generates a regexp matcher' do
    expect(described_class.matcher).to be_a Regexp
  end

  it 'recognizes input', skip: 'Matcher logic is complex and may change' do
    expect(described_class.matcher).to match example_batch_header_record
  end

  describe 'parses a record' do
    let(:record) { described_class.parse(example_batch_header_record) }
    let(:record_with_settlement_date) do
      described_class.parse(example_batch_header_record_settlement_date)
    end

    it 'record_type_code' do
      expect(record.record_type_code.to_ach).to eq '5'
    end

    it 'service_class_code' do
      expect(record.service_class_code.to_ach).to eq '220'
    end

    it 'company_name' do
      expect(record.company_name.to_ach).to eq 'DHI PAYROLL     '
    end

    it 'company_discretionary_data' do
      expect(record.company_discretionary_data.to_ach).to eq '                    '
    end

    it 'company_identification' do
      expect(record.company_identification.to_ach).to eq '2870327243'
    end

    it 'standard_entry_class_code' do
      expect(record.standard_entry_class_code.to_ach).to eq 'PPD'
    end

    it 'company_entry_description' do
      expect(record.company_entry_description.to_ach).to eq 'DHIPAYROLL'
    end

    it 'company_descriptive_date' do
      expect(record.company_descriptive_date.to_ach).to eq '090702'
    end

    it 'effective_entry_date' do
      expect(record.effective_entry_date.to_ach).to eq '081205'
    end

    it 'blank settlement_date_julian' do
      expect(record.settlement_date_julian.to_ach).to eq '   '
    end

    it 'settlement_date_julian' do
      expect(record_with_settlement_date.settlement_date_julian.to_ach).to eq '100'
    end

    it 'originator_status_code' do
      expect(record.originator_status_code.to_ach).to eq '1'
    end

    it 'originating_dfi_identification' do
      expect(record.originating_dfi_identification.to_ach).to eq '12400005'
    end

    it 'batch_number' do
      expect(record.batch_number.to_ach).to eq '0000001'
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
        'company_name',
        'company_discretionary_data',
        'company_identification',
        'standard_entry_class_code',
        'company_entry_description',
        'company_descriptive_date',
        'effective_entry_date',
        'settlement_date_julian',
        'originator_status_code',
        'originating_dfi_identification',
        'batch_number',
        'child_record_types',
        'klass'
      )
    end
  end

  describe 'instance generates json' do
    let(:record) { described_class.parse(example_batch_header_record) }
    let(:json) { JSON.parse(record.to_json) }

    it 'is well formed' do
      expect(json).to be_a Hash
    end

    it 'has the right keys' do
      expect(json.keys).to include(
        'metadata',
        'nacha_record_type',
        'record_type_code',
        'service_class_code',
        'company_name',
        'company_discretionary_data',
        'company_identification',
        'standard_entry_class_code',
        'company_entry_description',
        'company_descriptive_date',
        'effective_entry_date',
        'settlement_date_julian',
        'originator_status_code',
        'originating_dfi_identification',
        'batch_number'
      )
    end
  end
end
