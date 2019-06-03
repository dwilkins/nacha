require 'spec_helper'

RSpec.describe 'Nacha::Record::MteAddenda', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::MteAddenda }.to_not raise_error()
  end

end
