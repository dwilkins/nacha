require 'spec_helper'

RSpec.describe Nacha::Record::PosAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::PosAddenda }.not_to raise_error
  end
end
