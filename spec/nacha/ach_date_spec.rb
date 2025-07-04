require 'spec_helper'

RSpec.describe Nacha::AchDate do
  it 'can be created' do
    expect(described_class.new('170102')).to be_a described_class
  end

  it 'does Date-like things' do
    ach_date = described_class.new('170102')
    ach_date += 1
    expect(ach_date.to_s).to eq '170103'
    expect(ach_date.next_year.to_s).to eq '180103'
  end

  it "accepts year, month, day" do
    expect(described_class.new(2025, 6, 20).to_s).to eq '250620'
  end

  it "accepts year, month, day(float)" do
    expect(described_class.new(2025, 6, 20.1).to_s).to eq '250620'
  end

  it "throws argument errors for bad arguments" do
    expect { described_class.new(0..2) }.to raise_error(ArgumentError)
  end
end
