# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'
require 'open3'

RSpec.describe 'exe/nacha' do
  let(:executable_path) { File.expand_path('../../exe/nacha', __dir__) }
  let(:fixture_path) { File.expand_path('../fixtures/ccd-debit.ach', __dir__) }

  it 'parses a file and writes output to a file specified with -o' do
    Dir.mktmpdir do |dir|
      output_path = File.join(dir, 'output.html')
      _stdout, stderr, status = Open3.capture3(executable_path, 'parse', fixture_path, '-o', output_path)

      expect(status.success?).to be(true), "Command failed. STDERR:\n#{stderr}"
      expect(stderr).to be_empty

      expect(File.exist?(output_path)).to be true
      content = File.read(output_path)
      expect(content).to include("<h1>Successfully parsed #{fixture_path}</h1>")
    end
  end

  it 'parses a file and writes output to a file specified with --output-file' do
    Dir.mktmpdir do |dir|
      output_path = File.join(dir, 'output.html')
      _stdout, stderr, status = Open3.capture3(executable_path, 'parse', fixture_path, '--output-file', output_path)

      expect(status.success?).to be(true), "Command failed. STDERR:\n#{stderr}"
      expect(stderr).to be_empty

      expect(File.exist?(output_path)).to be true
      content = File.read(output_path)
      expect(content).to include("<h1>Successfully parsed #{fixture_path}</h1>")
    end
  end
end
