require 'spec_helper'

RSpec.describe "Nacha::Record::BatchControlRecord", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::BatchControlRecord }.to_not raise_error()
  end

end
