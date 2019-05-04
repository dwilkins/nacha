require 'spec_helper'

RSpec.describe "Nacha::Record::SecondIatAddenda", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::SecondIatAddenda }.to_not raise_error()
  end

end
