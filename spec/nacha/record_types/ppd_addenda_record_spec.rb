require 'spec_helper'

RSpec.describe "Nacha::Record::PpdAddendaRecord", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::PpdAddendaRecord }.to_not raise_error()
  end

  it 'knows it\'s name' do
    expect(Nacha::Record::PpdAddendaRecord.name).to eq 'ppd_addenda_record'
  end

end
