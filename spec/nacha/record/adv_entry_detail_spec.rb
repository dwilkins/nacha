require 'spec_helper'

RSpec.describe Nacha::Record::AdvEntryDetail, :nacha_record_type do
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
        'transaction_code',
        'receiving_dfi_identification',
        'dfi_account_number',
        'amount',
        'advice_routing_number',
        'file_identification',
        'ach_operator_data',
        'individual_name',
        'discretionary_data',
        'addenda_record_indicator',
        'routing_number_of_ach_operator',
        'julian_date_created',
        'sequence_number',
        'child_record_types',
        'klass'
      )
    end
  end
end
