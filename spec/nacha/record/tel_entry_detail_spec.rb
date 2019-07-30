require 'spec_helper'

RSpec.describe Nacha::Record::TelEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::TelEntryDetail }.not_to raise_error
  end
end
