require 'spec_helper'

RSpec.describe "Nacha::Record::ArcEntryDetail", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::ArcEntryDetail }.to_not raise_error()
  end

end
