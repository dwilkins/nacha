require 'spec_helper'

RSpec.describe Nacha::Record::PopEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::PopEntryDetail }.not_to raise_error
  end
end
