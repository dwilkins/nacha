require 'spec_helper'

RSpec.describe 'Nacha::Record::TrxAddenda', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::TrxAddenda }.to_not raise_error()
  end

end
