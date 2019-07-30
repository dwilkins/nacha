require 'spec_helper'

RSpec.describe Nacha::Record::EnrAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::EnrAddenda }.not_to raise_error
  end
end
