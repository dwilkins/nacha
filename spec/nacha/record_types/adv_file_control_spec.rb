require 'spec_helper'

RSpec.describe "Nacha::Record::AdvFileControl", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::AdvFileControl }.to_not raise_error()
  end

end
