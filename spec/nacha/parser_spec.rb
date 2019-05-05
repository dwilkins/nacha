require 'spec_helper'


RSpec.describe Nacha::Parser do
  let(:example_ach_file) do
    '101 124000054 1240000540907021214A094101ZIONS FIRST NATIONAL BAZIONS FIRST NATIONAL BA       1' +
      '5220DHI PAYROLL                         2870327243PPDDHIPAYROLL090702081205   1124000050000001' +
      '622124301025012345678        00000001000062           MARY V HOPEFUL          0124000050000001' +
      '622124301025527527527        00002000000527           MEAGUN R BOLSHAYAKVART  0124000050000002' +
      '822000000200248602040000000000000000002001002870327243                         124000050000001' +
      '9000001000001000000020024860204000000000000000000200100                                       ' +
      '9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999' +
      '9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999' +
      '9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999' +
      '9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999'
  end

  it 'file is not empty' do
    expect(example_ach_file.size).to be > 0
  end

  it 'parses a file' do
    # skip 'not working yet'
    parsed = Nacha::Parser.new.parse_string(example_ach_file)
    expect(parsed).to be_a Array
    expect(parsed.count).to eq 10
    expect(parsed[0]).to be_a Nacha::Record::FileHeader
    expect(parsed[1]).to be_a Nacha::Record::BatchHeader
    expect(parsed[2]).to be_a Nacha::Record::PpdEntryDetail
    expect(parsed[3]).to be_a Nacha::Record::PpdEntryDetail
    expect(parsed[4]).to be_a Nacha::Record::BatchControl
  end
end
