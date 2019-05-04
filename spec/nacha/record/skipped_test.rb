require 'spec_helper'

RSpec.describe "Nacha::Record::Missing", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::Missing }.to_not raise_error()
  end

end
