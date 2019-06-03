require 'spec_helper'

RSpec.describe 'Nacha::Record::CcdAddenda', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::CcdAddenda }.to_not raise_error()
  end

end
