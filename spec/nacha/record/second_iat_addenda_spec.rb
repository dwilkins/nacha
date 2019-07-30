require 'spec_helper'

RSpec.describe Nacha::Record::SecondIatAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::SecondIatAddenda }.not_to raise_error
  end
end
