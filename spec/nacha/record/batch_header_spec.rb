require 'spec_helper'

RSpec.describe 'Nacha::Record::BatchHeader', :nacha_record_type do
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
    expect(bh).to be_a Nacha::Record::BatchHeader
    expect(pbh).to be_a Nacha::Record::BatchHeader
    expect(bh.standard_entry_class_code.to_s).to eq('PPD')
    expect(pbh.standard_entry_class_code.to_s).to eq('PPD')
  end

  it 'exists' do
    expect { Nacha::Record::BatchHeader }.not_to raise_error
  end

  it 'generates a valid unpack string' do
    expect(Nacha::Record::BatchHeader.unpack_str).to eq 'A1a3A16A20A10A3A10A6A6a3A1A8a7'
  end

  it 'generates a regexp matcher' do
    expect(Nacha::Record::BatchHeader.matcher).to be_a Regexp
  end

  it 'recognizes input', skip: 'Matcher logic is complex and may change' do
    expect(Nacha::Record::BatchHeader.matcher).to match example_batch_header_record
  end

  describe 'parses a record' do
    let(:record) { Nacha::Record::BatchHeader.parse(example_batch_header_record) }
    let(:record_with_settlement_date) do
      Nacha::Record::BatchHeader.parse(example_batch_header_record_settlement_date)
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
end
