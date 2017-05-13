require 'spec_helper'

RSpec.describe "Nacha::Record::PpdEntryDetail", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::PpdEntryDetail }.to_not raise_error()
  end

end
