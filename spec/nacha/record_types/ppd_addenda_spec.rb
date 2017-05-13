require 'spec_helper'

RSpec.describe "Nacha::Record::PpdAddenda", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::PpdAddenda }.to_not raise_error()
  end

  it 'knows it\'s name' do
    expect(Nacha::Record::PpdAddenda.name).to eq 'ppd_addenda'
  end

end
