require 'spec_helper'

RSpec.describe "Nacha::Record::CtxAddenda", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::CtxAddenda }.to_not raise_error()
  end

end
