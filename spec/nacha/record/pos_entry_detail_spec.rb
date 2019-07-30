require 'spec_helper'

RSpec.describe Nacha::Record::PosEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::PosEntryDetail }.not_to raise_error
  end
end
