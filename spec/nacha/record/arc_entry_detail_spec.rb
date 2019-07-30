require 'spec_helper'

RSpec.describe Nacha::Record::ArcEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::ArcEntryDetail }.not_to raise_error
  end
end
