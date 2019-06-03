require 'spec_helper'

RSpec.describe 'Nacha::Record::FileControl', :nacha_record_type do

  let(:example_file_control_record) {
    #         1         2         3         4         5         6         7         8         9
    #1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
    '9000001000001000000020024860204000000000000000000200100                                       '
  }


  it 'exists' do
    expect { Nacha::Record::FileControl }.to_not raise_error()
  end

  it 'generates a valid unpack string' do
    expect(Nacha::Record::FileControl.unpack_str).to eq 'A1a6a6a8a10a12a12A39'
  end

  it 'generates a regexp matcher' do
    expect(Nacha::Record::FileControl.matcher).to be_a Regexp
  end

  it 'recognizes input' do
    expect(Nacha::Record::FileControl.matcher).to match example_file_control_record
  end

  describe 'parses a record' do
    let(:fcr) { Nacha::Record::FileControl.parse(example_file_control_record) }
    let(:fcr_hash) do
      {
        nacha_record_type: 'file_control',
        batch_count: 1,
        block_count: 1,
        entry_addenda_count: 2,
        entry_hash: 24860204,
        record_type_code: '9',
        reserved: '',
        total_credit_entry_dollar_amount_in_file: 2001.0,
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
      expect(fcr.entry_hash.to_ach).to eq '0024860204'
    end

    it 'total_debit_entry_dollar_amount_in_file' do
      expect(fcr.total_debit_entry_dollar_amount_in_file.to_ach).to eq '000000000000'
    end

    it 'total_credit_entry_dollar_amount_inf_file' do
      expect(fcr.total_credit_entry_dollar_amount_in_file.to_ach).to eq '000000200100'
    end

    it 'converts to a hash' do
      expect(fcr.to_h).to eq(fcr_hash)
    end

    it 'converts to json' do
      expect(JSON.parse(fcr.to_json).values).to contain_exactly(*fcr_hash.values)
      expect(JSON.parse(fcr.to_json).keys).to contain_exactly(*(fcr_hash.keys.collect(&:to_s)))
    end
  end
end
