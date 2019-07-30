require 'spec_helper'

RSpec.describe Nacha::Record::SixthIatAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::SixthIatAddenda }.not_to raise_error
  end
end
