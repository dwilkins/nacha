require 'spec_helper'

RSpec.describe 'Nacha::Record::ShrEntryDetail', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::ShrEntryDetail }.to_not raise_error()
  end

end
