require 'spec_helper'

RSpec.describe "Nacha::Record::DneEntryDetail", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::DneEntryDetail }.to_not raise_error()
  end

end