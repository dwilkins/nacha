require 'spec_helper'

RSpec.describe 'Nacha::Record::TrcEntryDetail', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::TrcEntryDetail }.to_not raise_error()
  end

end
