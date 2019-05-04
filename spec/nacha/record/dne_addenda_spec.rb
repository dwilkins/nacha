require 'spec_helper'

RSpec.describe "Nacha::Record::DneAddenda", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::DneAddenda }.to_not raise_error()
  end

end
