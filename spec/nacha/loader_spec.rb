require 'spec_helper'


RSpec.describe Nacha::Loader do


  it 'reads definitions' do
    loader = Nacha::Loader.new
    expect(loader.record_defs['file_header_record']).to_not be_nil
  end

  it 'creates classes' do
    if(Nacha::Record.const_get('FileHeaderRecord'))
      Nacha::Record.send(:remove_const,'FileHeaderRecord')
    end
    expect { Nacha::Record::FileHeaderRecord }.to raise_error(NameError)
    loader = Nacha::Loader.new
    expect { Nacha::Record::FileHeaderRecord }.to_not raise_error()
  end

end
