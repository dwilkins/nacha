require 'spec_helper'

RSpec.describe Nacha::Record::DneAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::DneAddenda }.not_to raise_error
  end
end
