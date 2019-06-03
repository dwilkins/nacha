require 'spec_helper'

RSpec.describe 'Nacha::Record::ShrAddenda', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::ShrAddenda }.to_not raise_error()
  end

end
