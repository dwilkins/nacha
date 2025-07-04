require 'spec_helper'

RSpec.describe Nacha::Record::CtxAddenda, :nacha_record_type do
  it 'exists' do
    expect { described_class }.not_to raise_error
  end
end
