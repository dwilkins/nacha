require 'spec_helper'

RSpec.describe Nacha::Record::WebAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::WebAddenda }.not_to raise_error
  end
end
