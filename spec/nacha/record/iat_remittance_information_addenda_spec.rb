require 'spec_helper'

RSpec.describe Nacha::Record::IatRemittanceInformationAddenda, :nacha_record_type do
  it 'exists' do
    expect { described_class }.not_to raise_error
  end
end
