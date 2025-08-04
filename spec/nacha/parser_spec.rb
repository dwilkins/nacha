require 'spec_helper'

RSpec.describe Nacha::Parser do
  let(:example_ach_file) do
    #           1         2         3         4         5         6         7         8         9
    #  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
    '' \
      '101 124000054 1240000540907021214A094101ZIONS FIRST NATIONAL BAZIONS FIRST NATIONAL BA       1' \
      '5220DHI PAYROLL                         2870327243PPDDHIPAYROLL090702081205   1124000050000001' \
      '622124301025012345678        00000001000062           MARY V HOPEFUL          0124000050000001' \
      '622124301025527527527        00002000000527           MEAGUN R BOLSHAYAKVART  0124000050000002' \
      '822000000200248602040000000000000000002001002870327243                         124000050000001' \
      '9000001000001000000020024860204000000000000000000200100                                       ' \
      '9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999' \
      '9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999' \
      '9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999' \
      '9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999'
  end

  let(:truncated_ach_file) do
    #           1         2         3         4         5         6         7         8         9
    #  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
    "" \
      "101 03130001202313801041908161055A094101Federal Reserve Bank   My Bank Name           12345678" \
      "5225Name on Account                     231380104 CCDVndr Pay        190816   1031300010000001" \
      "627231380104744-5678-99      0000500000location1234567Best Co. #123456789012S 0031300010000001" \
      "627231380104744-5678-99      0000000125Fee123456789012Best Co. #123456789012S 0031300010000002" \
      "82250000020046276020000000500125000000000000231380104                          031300010000001" \
      "9000001000001000000020046276020000000500125000000000000                                   \n" \
      "9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999" \
      "9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999" \
      "9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999" \
      "9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
  end

  it 'file is not empty' do
    expect(example_ach_file.size).to be > 0
  end

  it 'parses a file' do
    records = described_class.new.parse_string(example_ach_file)
    expect(records).to be_a Array
    expect(records.count).to eq 10
    expect(records[0]).to be_a Nacha::Record::FileHeader
    expect(records[1]).to be_a Nacha::Record::BatchHeader
    expect(records[2]).to be_a Nacha::Record::PpdEntryDetail
    expect(records[3]).to be_a Nacha::Record::PpdEntryDetail
    expect(records[4]).to be_a Nacha::Record::BatchControl
  end

  it 'parses a truncated file' do
    records = described_class.new.parse_string(truncated_ach_file)
    expect(records).to be_a Array
    expect(records.count).to eq 10
    expect(records[0]).to be_a Nacha::Record::FileHeader
    expect(records[1]).to be_a Nacha::Record::BatchHeader
    expect(records[2]).to be_a Nacha::Record::CcdEntryDetail
    expect(records[3]).to be_a Nacha::Record::CcdEntryDetail
    expect(records[4]).to be_a Nacha::Record::BatchControl
  end

  it 'parses a string' do
    expect_any_instance_of(described_class).to receive(:parse_string).once
    Nacha.parse("")
  end
end
