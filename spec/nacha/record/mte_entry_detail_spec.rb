require 'spec_helper'

RSpec.describe Nacha::Record::MteEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::MteEntryDetail }.not_to raise_error
  end
end
