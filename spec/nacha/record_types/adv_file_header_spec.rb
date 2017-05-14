require 'spec_helper'

RSpec.describe "Nacha::Record::AdvFileHeader", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::AdvFileHeader }.to_not raise_error()
  end

end
