require 'spec_helper'

RSpec.describe Nacha::Record::IatRemittanceInformationAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::IatRemittanceInformationAddenda }.not_to raise_error
  end
end
