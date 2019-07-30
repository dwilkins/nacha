require 'spec_helper'

RSpec.describe Nacha::Record::Base, :nacha_record_type do
  it 'fields can be loaded' do
    record = Nacha::Record::FileHeader.new
    expect(record.record_type_code.to_ach).to eq '1'
  end
end
