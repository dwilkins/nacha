require 'spec_helper'

RSpec.describe Nacha::Record::Filler, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::Filler }.not_to raise_error
  end

  it 'generates a valid unpack string' do
    expect(Nacha::Record::Filler.unpack_str).to eq 'A1a93'
  end
end
