require 'spec_helper'

RSpec.describe "Nacha::Record::CieEntryDetail", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::CieEntryDetail }.to_not raise_error()
  end

end
