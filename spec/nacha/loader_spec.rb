require 'spec_helper'


RSpec.describe Nacha::Loader do


  it 'reads definitions' do
    loader = Nacha::Loader.new
    expect(loader.record_defs['file_header_record']).to_not be_nil
  end

end
