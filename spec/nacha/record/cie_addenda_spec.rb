require 'spec_helper'

RSpec.describe Nacha::Record::CieAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::CieAddenda }.not_to raise_error
  end
end
