require 'spec_helper'

RSpec.describe Nacha::Record::IatBatchHeader, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::IatBatchHeader }.not_to raise_error
  end
end
