require 'spec_helper'

RSpec.describe "Nacha::Record::FileControlRecord", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::FileControlRecord }.to_not raise_error()
  end

end
