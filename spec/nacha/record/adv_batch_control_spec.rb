require 'spec_helper'

RSpec.describe "Nacha::Record::AdvBatchControl", :nacha_record_type do

  let(:subject) { Nacha::Record::AdvBatchControl }
  let(:example_adv_batch_control_record) {
    #         1         2         3         4         5         6         7         8         9
    #1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
    "822000000200248602040000000000000000002001002870327243                         124000050000001"
  }

  it 'exists' do
    expect { subject }.to_not raise_error()
  end

  it 'generates a valid unpack string' do
    expect(subject.unpack_str).to eq 'A1a3a6a10a20a20A19A8a7'
  end

  it 'generates a regexp matcher' do
    expect(subject.matcher).to be_a Regexp
  end

  describe 'parses a record' do
    let(:abcr) { Nacha::Record::BatchControl.parse(example_adv_batch_control_record) }

    it 'record_type_code' do
      expect(abcr.record_type_code.to_ach).to eq '8'
    end
  end
end
