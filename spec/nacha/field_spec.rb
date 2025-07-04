require 'spec_helper'

RSpec.describe Nacha::Field do
  let(:valid_params) do
    {
      inclusion: 'M',
      contents: 'C1',
      position: 1..1
    }
  end

  it 'is one' do
    expect(described_class.new).to be_a described_class
  end

  describe 'defaults' do
    it 'data type' do
      expect(described_class.new(valid_params).data_type).to eq String
    end

    it 'justification' do
      expect(described_class.new(valid_params).justification).to eq :ljust
    end

    it 'fill character' do
      expect(described_class.new(valid_params).fill_character).to eq ' '
    end
  end

  describe 'validates' do
    [:inclusion, :contents, :position].each do |attr|
      describe attr.to_s do
        it 'must be present' do
          expect(described_class.new(valid_params)).to be_valid
          valid_params.delete(attr)
          expect(described_class.new(valid_params)).not_to be_valid
        end
      end
    end
  end

  describe 'responds' do
    let(:optional_field) { build(:company_descriptive_date) }
    let(:mandatory_field) { build(:standard_entry_class_code) }
    let(:required_field) { build(:effective_entry_date) }

    it 'to mandatory?' do
      expect(mandatory_field).to be_mandatory
      expect(mandatory_field).not_to be_optional
      expect(mandatory_field).not_to be_required
    end

    it 'to optional?' do
      expect(optional_field).to be_optional
      expect(optional_field).not_to be_mandatory
      expect(optional_field).not_to be_required
    end

    it 'to required?' do
      expect(required_field).to be_required
      expect(required_field).not_to be_optional
      expect(required_field).not_to be_mandatory
    end
  end

  describe 'contents' do
    describe 'constants' do
      it 'sets the value' do
        expect(described_class.new(valid_params).to_ach).to eq '1'
      end
    end

    describe 'Numeric' do
      let(:valid_params) do
        {
          inclusion: 'M',
          contents: 'Numeric',
          position: 1..10
        }
      end

      it 'is right justified' do
        expect(described_class.new(valid_params).justification).to eq :rjust
      end

      it 'converts strings' do
        field = described_class.new(valid_params)
        field.data = '100'
        expect(field.to_ach).to eq '0000000100'
      end
    end

    describe 'ABA Numbers' do
      let(:valid_params) do
        {
          inclusion: 'M',
          contents: 'bTTTTAAAAC',
          position: 14..23
        }
      end
      let(:aba_number) { ' 051009296' }

      it 'can be created' do
        field = described_class.new(valid_params)
        field.data = ' 051009296'
        expect(field).to be_valid
      end

      it 'output correctly' do
        field = described_class.new(valid_params)
        field.data = aba_number
        expect(field).to be_valid
        expect(field.to_ach).to eq aba_number
      end
    end

    describe 'YYMMDD dates' do
      let(:valid_params) do
        {
          inclusion: 'M',
          contents: 'YYMMDD',
          position: 24..29
        }
      end
      let(:ambiguous_date) { '170102' }

      it 'can be created' do
        field = described_class.new(valid_params)
        field.data = ambiguous_date
        expect(field).to be_valid
      end

      it 'output correctly' do
        field = described_class.new(valid_params)
        field.data = ambiguous_date
        expect(field).to be_valid
        expect(field.to_ach).to eq ambiguous_date
      end

      it 'behaves like a date' do
        field = described_class.new(valid_params)
        field.data = ambiguous_date
        expect(field.data).to be_a Date
        field.data += 1
        expect(field.data).to eq Date.strptime(ambiguous_date, '%y%m%d') + 1
      end
    end
  end
end
