require 'spec_helper'

RSpec.describe Nacha::Record::XckEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::XckEntryDetail }.not_to raise_error
  end
end
