require 'spec_helper'

RSpec.describe "Nacha::Record::FirstIatAddenda", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::FirstIatAddenda }.to_not raise_error()
  end

end
