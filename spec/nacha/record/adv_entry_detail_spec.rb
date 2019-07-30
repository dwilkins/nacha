require 'spec_helper'

RSpec.describe Nacha::Record::AdvEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::AdvEntryDetail }.not_to raise_error
  end
end
