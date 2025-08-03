require 'spec_helper'
require 'nacha/formatter'

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

  describe 'class generates json' do
    let(:class_json) { JSON.pretty_generate(described_class.to_h) }

    it 'is well formed' do
      expect(JSON.parse(class_json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(class_json)[described_class.record_type].keys).to include(
        'record_type_code',
        'transaction_code',
        'receiving_dfi_identification',
        'dfi_account_number',
        'amount',
        'individual_identification_number',
        'individual_name',
        'discretionary_data',
        'addenda_record_indicator',
        'trace_number',
        'child_record_types',
        'klass'
      )
    end
  end

  describe 'instance generates json' do
    let(:json) { JSON.parse(build(:debit_ppd_entry_detail).to_json) }

    it 'is well formed' do
      expect(json).to be_a Hash
    end

    it 'has the right keys' do
      expect(json.keys).to include(
        'metadata',
        'nacha_record_type',
        'record_type_code',
        'transaction_code',
        'receiving_dfi_identification',
        'dfi_account_number',
        'amount',
        'individual_identification_number',
        'individual_name',
        'discretionary_data',
        'addenda_record_indicator',
        'trace_number'
      )
    end
  end
end
