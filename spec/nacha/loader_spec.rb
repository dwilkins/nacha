require 'spec_helper'


RSpec.describe Nacha::Loader do


  it 'reads definitions' do
    loader = Nacha::Loader.instance
    expect(loader.record_defs['file_header']).to_not be_nil
  end

  it 'creates classes' do
    if(Nacha::Record.const_get('FileHeader'))
      Nacha::Record.send(:remove_const,'FileHeader')
    end
    expect { Nacha::Record::FileHeader }.to raise_error(NameError)
    loader = Nacha::Loader.instance
    loader.load
    expect { Nacha::Record::FileHeader }.to_not raise_error()
  end

end
