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
    it 'handles constants' do
      expect(Nacha::Field.new(valid_params).to_ach).to eq '1'
    end
  end

end
