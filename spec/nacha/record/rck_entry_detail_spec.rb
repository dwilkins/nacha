require 'spec_helper'

RSpec.describe Nacha::Record::RckEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::RckEntryDetail }.not_to raise_error
  end
end
