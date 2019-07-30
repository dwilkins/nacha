require 'spec_helper'

RSpec.describe Nacha::Record::IatForeignCoorespondentBankInformationAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::IatForeignCoorespondentBankInformationAddenda }.not_to raise_error
  end
end
