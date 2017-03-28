require 'spec_helper'

RSpec.describe "Nacha::Record::BatchHeaderRecord", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::BatchHeaderRecord }.to_not raise_error()
  end

end
