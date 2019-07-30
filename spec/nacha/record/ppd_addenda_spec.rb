require 'spec_helper'

RSpec.describe Nacha::Record::PpdAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::PpdAddenda }.not_to raise_error
  end
end
