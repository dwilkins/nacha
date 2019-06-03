require 'spec_helper'

RSpec.describe 'Nacha::Record::FifthIatAddenda', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::FifthIatAddenda }.to_not raise_error()
  end

end
