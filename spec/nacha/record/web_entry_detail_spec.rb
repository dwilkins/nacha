require 'spec_helper'

RSpec.describe Nacha::Record::WebEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::WebEntryDetail }.not_to raise_error
  end
end
