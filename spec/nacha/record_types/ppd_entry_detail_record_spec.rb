require 'spec_helper'

RSpec.describe "Nacha::Record::PpdEntryDetailRecord", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::PpdEntryDetailRecord }.to_not raise_error()
  end

end