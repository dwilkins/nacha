require 'spec_helper'

RSpec.describe Nacha::Record::Filler, :nacha_record_type do
  let(:subject) { Nacha::Record::Filler }
  let(:example_filler_record) do
    #         1         2         3         4         5         6         7         8         9
    #1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
    '9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999'
  end


  it 'exists' do
    expect { Nacha::Record::Filler }.not_to raise_error
  end

  it 'generates a valid unpack string' do
    expect(Nacha::Record::Filler.unpack_str).to eq 'A1a93'
  end

  it 'generates a regexp matcher' do
    expect(Nacha::Record::Filler.matcher).to be_a Regexp
  end

  it 'is valid with a valid filler record' do
    filler_record = subject.parse(example_filler_record)
    expect(filler_record).to be_valid
  end

  it 'is invalid with an invalid filler record' do
    invalid_filler_record = '9234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234'
    filler_record = subject.parse(invalid_filler_record)
    puts filler_record.inspect
    expect(filler_record).to_not be_valid, filler_record.errors&.join(', ').to_s
    expect(filler_record.class).to eq Nacha::Record::Filler
    expect(filler_record.errors).to_not be_empty
  end

end
