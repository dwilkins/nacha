require 'spec_helper'

RSpec.describe 'Nacha::Record::IatForeignCoorespondentBankInformation', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::IatForeignCoorespondentBankInformationAddenda }.to_not raise_error()
  end

end
