require 'spec_helper'

RSpec.describe Nacha::Record::IatEntryDetail, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::IatEntryDetail }.not_to raise_error
  end
end
