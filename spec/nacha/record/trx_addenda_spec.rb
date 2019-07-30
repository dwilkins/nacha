require 'spec_helper'

RSpec.describe Nacha::Record::TrxAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::TrxAddenda }.not_to raise_error
  end
end
