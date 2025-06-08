require 'spec_helper'
require 'pry'
require 'byebug'

RSpec.describe 'Nacha::Record::AdvBatchControl', :nacha_record_type do
  let(:subject) { Nacha::Record::AdvBatchControl }
  let(:example_adv_batch_control_record) do
    #         1         2         3         4         5         6         7         8         9
    #1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
    '822000000200248602040000000000000000002001002870327243                         124000050000001'
  end

  it 'exists' do
    expect { subject }.not_to raise_error
  end

  it 'generates a valid unpack string' do
    expect(subject.unpack_str).to eq 'A1a3a6a10a20a20A19A8a7'
  end

  it 'generates a regexp matcher' do
    expect(subject.matcher).to be_a Regexp
  end

  describe 'valid record' do
    let(:abcr) { subject.parse(example_adv_batch_control_record) }

    it 'has a record_type_code' do
      expect(abcr.record_type_code.to_ach).to eq '8'
    end

    it 'is valid' do
      expect(abcr).to be_valid
    end
  end

  describe 'invalid record' do
    let(:example_adv_batch_control_record) do
      #         1         2         3         4         5         6         7         8         9
      #1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
      '8999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999991'
    end

    let(:abcr) { Nacha::Record::AdvBatchControl.parse(example_adv_batch_control_record) }

    it 'has a record_type_code' do
      expect(abcr.record_type_code.to_ach).to eq '8'
    end

    it 'is valid' do
      expect(abcr).to_not be_valid, abcr.errors&.join(', ').to_s
      expect(abcr.class).to eq Nacha::Record::AdvBatchControl
      expect(abcr.errors).to_not be_empty
    end
  end
end

