require 'spec_helper'

RSpec.describe Nacha::AchDate do
  it 'can be created' do
    expect(described_class.new('170102')).to be_a described_class
  end

  it 'Does Date-like things' do
    ach_date = described_class.new('170102')
    ach_date += 1
    expect(ach_date.to_s).to eq '170103'
    expect(ach_date.next_year.to_s).to eq '180103'
  end
end
