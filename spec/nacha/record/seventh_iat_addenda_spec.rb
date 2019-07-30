require 'spec_helper'

RSpec.describe Nacha::Record::SeventhIatAddenda, :nacha_record_type do
  it 'exists' do
    expect { Nacha::Record::SeventhIatAddenda }.not_to raise_error
  end
end
