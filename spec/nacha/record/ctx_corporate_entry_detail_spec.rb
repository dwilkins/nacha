require 'spec_helper'

RSpec.describe 'Nacha::Record::CtxCorporateEntryDetail', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::CtxCorporateEntryDetail }.to_not raise_error()
  end

end
