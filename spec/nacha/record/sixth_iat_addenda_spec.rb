require 'spec_helper'

RSpec.describe "Nacha::Record::SixthIatAddenda", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::SixthIatAddenda }.to_not raise_error()
  end

end
