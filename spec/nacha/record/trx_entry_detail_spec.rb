require 'spec_helper'

RSpec.describe Nacha::Record::TrxEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::TrxEntryDetail }.not_to raise_error
  end
end
