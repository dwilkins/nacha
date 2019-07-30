require 'spec_helper'

RSpec.describe Nacha::Record::ThirdIatAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::ThirdIatAddenda }.not_to raise_error
  end
end
