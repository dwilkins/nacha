require 'spec_helper'

RSpec.describe "Nacha::Record::BocEntryDetail", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::BocEntryDetail }.to_not raise_error()
  end

end