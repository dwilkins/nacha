require 'spec_helper'

RSpec.describe "Nacha::Record::TelEntryDetail", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::TelEntryDetail }.to_not raise_error()
  end

end