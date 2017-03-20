require "spec_helper"

RSpec.describe Nacha::Field do
  let(:valid_params) do
    {
      inclusion: 'M',
      contents: 'C1',
      position: 1..1
    }
  end

  it "is one" do
    expect(Nacha::Field.new).to be_a Nacha::Field
  end

  describe "defaults" do
    it 'data type' do
      expect(Nacha::Field.new(valid_params).data_type).to eq String
    end

    it 'justification' do
      expect(Nacha::Field.new(valid_params).justification).to eq :ljust
    end

    it 'fill character' do
      expect(Nacha::Field.new(valid_params).fill_character).to eq ' '
    end
  end

  describe 'validates' do
    [:inclusion, :contents, :position].each do |attr|
      describe "#{attr}"  do
        it 'must be present' do
          expect(Nacha::Field.new(valid_params).valid?).to be_truthy
          valid_params.delete(attr)
          expect(Nacha::Field.new(valid_params).valid?).to be_falsy
        end
      end
    end
  end

  describe 'contents' do
    describe 'constants' do
      it 'sets the value' do
        expect(Nacha::Field.new(valid_params).to_ach).to eq '1'
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
        expect(Nacha::Field.new(valid_params).justification).to eq :rjust
      end

      it 'converts strings' do
        field = Nacha::Field.new(valid_params)
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
        field = Nacha::Field.new(valid_params)
        field.data = ' 051009296'
        expect(field.valid?).to be_truthy
      end
      it 'output correctly' do
        field = Nacha::Field.new(valid_params)
        field.data = aba_number
        expect(field.valid?).to be_truthy
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
        field = Nacha::Field.new(valid_params)
        field.data = ambiguous_date
        expect(field.valid?).to be_truthy
      end

      it 'output correctly' do
        field = Nacha::Field.new(valid_params)
        field.data = ambiguous_date
        expect(field.valid?).to be_truthy
        expect(field.to_ach).to eq ambiguous_date
      end

      it 'behaves like a date' do
        field = Nacha::Field.new(valid_params)
        field.data = ambiguous_date
        expect(field.data).to be_a Date
        field.data += 1
        expect(field.data).to eq (Date.strptime(ambiguous_date,"%y%m%d") + 1)
      end
    end

  end

end
