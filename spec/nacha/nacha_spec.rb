require 'spec_helper'

RSpec.describe Nacha do
  it 'parses a string' do
    expect_any_instance_of(Nacha::Parser).to receive(:parse_string).once
    subject.parse("")
  end

  # Anything other than a string is assumed to be a file
  # TODO: better file / URL handling
  it 'parses a file' do
    expect_any_instance_of(Nacha::Parser).to receive(:parse_file).once
    subject.parse(nil)
  end

end
