require 'spec_helper'

RSpec.describe 'Nacha::Record::IatRemittanceInformationAddenda', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::IatRemittanceInformationAddenda }.to_not raise_error()
  end

end
