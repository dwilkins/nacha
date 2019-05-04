require 'spec_helper'

RSpec.describe "Nacha::Record::ThirdIatAddenda", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::ThirdIatAddenda }.to_not raise_error()
  end

end
