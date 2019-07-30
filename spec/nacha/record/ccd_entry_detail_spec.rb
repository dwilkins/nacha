require 'spec_helper'

RSpec.describe Nacha::Record::CcdEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::CcdEntryDetail }.not_to raise_error
  end
end
