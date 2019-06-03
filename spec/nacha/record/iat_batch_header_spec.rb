require 'spec_helper'

RSpec.describe 'Nacha::Record::IatBatchHeader', :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::IatBatchHeader }.to_not raise_error()
  end

end
