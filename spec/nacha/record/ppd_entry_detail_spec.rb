require 'spec_helper'

RSpec.describe "Nacha::Record::PpdEntryDetail", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::PpdEntryDetail }.to_not raise_error()
  end

  describe 'transaction' do
    it 'debit' do
      expect(build(:debit_ppd_entry_detail)).to be_debit
    end

    it 'credit' do
      expect(build(:credit_ppd_entry_detail)).to be_credit
    end
  end

end
