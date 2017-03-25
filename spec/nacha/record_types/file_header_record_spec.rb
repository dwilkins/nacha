require 'spec_helper'

RSpec.describe "Nacha::Record::FileHeaderRecord", :nacha_record_type do

  let(:example_file_header_record) {
    "101 124000054 1240000540907021214A094101ZIONS FIRST NATIONAL BAZIONS FIRST NATIONAL BA       1"
  }

  it 'exists' do
    expect { Nacha::Record::FileHeaderRecord }.to_not raise_error()
  end

  it 'generates a valid unpack string' do
    expect(Nacha::Record::FileHeaderRecord.unpack_str).to eq 'A1A2A10A10A6A4A1A3A2A1A23A23A8'
  end

  it 'generates a regexp matcher' do
    expect(Nacha::Record::FileHeaderRecord.matcher).to be_a Regexp
  end

  it 'generates a valid matcher' do
    expect(Nacha::Record::FileHeaderRecord.matcher).to eq /\A1.................................094101......................................................\z/
  end

  it 'recognizes input' do
    expect(Nacha::Record::FileHeaderRecord.matcher).to match example_file_header_record
  end


end
