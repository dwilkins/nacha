require 'spec_helper'

RSpec.describe Nacha::Record::DneEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::DneEntryDetail }.not_to raise_error
  end
end
