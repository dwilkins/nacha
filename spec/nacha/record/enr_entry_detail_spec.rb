require 'spec_helper'

RSpec.describe Nacha::Record::EnrEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::EnrEntryDetail }.not_to raise_error
  end
end
