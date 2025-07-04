require 'spec_helper'

RSpec.describe Nacha::Record::PpdEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { described_class }.not_to raise_error
  end

  describe 'transaction' do
    it 'debit' do
      expect(build(:debit_ppd_entry_detail)).to be_valid
      expect(build(:debit_ppd_entry_detail)).to be_debit
    end

    it 'credit' do
      expect(build(:credit_ppd_entry_detail)).to be_valid
      expect(build(:credit_ppd_entry_detail)).to be_credit
    end
  end

  describe 'output' do
    describe 'to_ach' do
      it 'is the right size' do
        expect(build(:debit_ppd_entry_detail).to_ach.length).to be(94)
      end
    end
  end
end
