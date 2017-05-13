require 'spec_helper'

RSpec.describe "Nacha::Record::BatchControl", :nacha_record_type do

  let(:example_batch_control_record) {
    #         1         2         3         4         5         6         7         8         9
    #1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
    "822000000200248602040000000000000000002001002870327243                         124000050000001"
  }


  it 'exists' do
    expect { Nacha::Record::BatchControl }.to_not raise_error()
  end

  it 'generates a valid unpack string' do
    expect(Nacha::Record::BatchControl.unpack_str).to eq 'A1A3A6A10A12A12A10A19A6A8A7'
  end

  it 'generates a regexp matcher' do
    expect(Nacha::Record::BatchControl.matcher).to be_a Regexp
  end

  it 'recognizes input' do
    expect(Nacha::Record::BatchControl.matcher).to match example_batch_control_record
  end
  describe 'parses a record' do
    let(:bcr) { Nacha::Record::BatchControl.parse(example_batch_control_record) }

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
end
