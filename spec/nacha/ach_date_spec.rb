require 'spec_helper'

RSpec.describe Nacha::AchDate do

  it 'can be created' do
    expect(Nacha::AchDate.new('170102')).to be_a Nacha::AchDate
  end

  it 'Does Date-like things' do
    ach_date = Nacha::AchDate.new('170102')
    ach_date += 1
    expect(ach_date.to_s).to eq '170103'
    expect(ach_date.next_year.to_s).to eq '180103'
  end


end
