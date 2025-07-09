require 'spec_helper'

RSpec.describe Nacha::Record::IatBatchHeader, :nacha_record_type do
  it 'exists' do
    expect { described_class }.not_to raise_error
  end

  describe 'class generates json' do
    let(:class_json) { described_class.to_json }

    it 'is well formed' do
      expect(JSON.parse(class_json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(class_json)[described_class.record_type].keys).to include(
        'record_type_code',
        'service_class_code',
        'iat_indicator',
        'foreign_exchange_indicator',
        'foreign_exchange_reference_indicator',
        'foreign_exchange_reference',
        'iso_destination_country_code',
        'originator_identification',
        'standard_entry_class_code',
        'company_entry_description',
        'iso_originating_currency_code',
        'iso_destination_currency_code',
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
    let(:json) { described_class.new.to_json }

    it 'is well formed' do
      expect(JSON.parse(json)).to be_a Hash
    end

    it 'has the right keys' do
      expect(JSON.parse(json).keys).to include(
        'metadata',
        'nacha_record_type',
        'record_type_code',
        'service_class_code',
        'iat_indicator',
        'foreign_exchange_indicator',
        'foreign_exchange_reference_indicator',
        'foreign_exchange_reference',
        'iso_destination_country_code',
        'originator_identification',
        'standard_entry_class_code',
        'company_entry_description',
        'iso_originating_currency_code',
        'iso_destination_currency_code',
        'effective_entry_date',
        'settlement_date_julian',
        'originator_status_code',
        'originating_dfi_identification',
        'batch_number'
      )
    end
  end
end
