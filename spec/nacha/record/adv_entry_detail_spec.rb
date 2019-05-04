require 'spec_helper'

RSpec.describe "Nacha::Record::AdvEntryDetail", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::AdvEntryDetail }.to_not raise_error()
  end

end
