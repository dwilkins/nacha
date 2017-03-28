require 'spec_helper'

RSpec.describe "Nacha::Record::PpdAddendaRecord", :nacha_record_type do

  it 'exists' do
    expect { Nacha::Record::PpdAddendaRecord }.to_not raise_error()
  end

end
