require 'spec_helper'

RSpec.describe 'Nacha::Record::CcdEntryDetail', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::CcdEntryDetail }.to_not raise_error()
  end

end
