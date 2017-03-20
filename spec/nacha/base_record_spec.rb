require 'spec_helper'


RSpec.describe Nacha::BaseRecord do

  let(:file_header_record_def) { YAML.load(File.read('lib/config/definitions/file_header_record.yml')) }


  it 'fields can be loaded' do
    record = Nacha::BaseRecord.new({ definition: file_header_record_def })
    expect(record.record_type_code.to_ach).to eq '1'
  end


end
