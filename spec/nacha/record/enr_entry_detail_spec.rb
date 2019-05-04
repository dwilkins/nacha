require 'spec_helper'

RSpec.describe "Nacha::Record::EnrEntryDetail", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::EnrEntryDetail }.to_not raise_error()
  end

end
