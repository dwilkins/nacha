# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'
require 'open3'

RSpec.describe 'Nacha CLI' do
  let(:executable) { File.expand_path('../../exe/nacha', __dir__) }
  let(:fixture_path) { File.expand_path('../fixtures/ccd-debit.ach', __dir__) }
  let(:non_existent_file) { 'non_existent_file.ach' }

  describe 'parse command' do
    context 'when printing to stdout' do
      it 'parses the file and prints a success message' do
        stdout, stderr, status = Open3.capture3(executable, 'parse', fixture_path)

        expect(status.success?).to be(true), "Command failed. STDERR:\n#{stderr}"
        expect(stderr).to be_empty
        expect(stdout).to include('data-name="record-number"')
      end
    end

    context 'when writing to an output file' do
      it 'parses a file and writes output to a file specified with -o' do
        Dir.mktmpdir do |dir|
          output_path = File.join(dir, 'output.html')
          _stdout, stderr, status = Open3.capture3(executable, 'parse', fixture_path, '-o', output_path)

          expect(status.success?).to be(true), "Command failed. STDERR:\n#{stderr}"
          expect(stderr).to be_empty

          expect(File.exist?(output_path)).to be true
          content = File.read(output_path)
          expect(content).to include('data-name="record-number"')
        end
      end

      it 'parses a file and writes output to a file specified with --output-file' do
        Dir.mktmpdir do |dir|
          output_path = File.join(dir, 'output.html')
          _stdout, stderr, status = Open3.capture3(
            executable, 'parse', fixture_path, '--output-file', output_path
          )

          expect(status.success?).to be(true), "Command failed. STDERR:\n#{stderr}"
          expect(stderr).to be_empty

          expect(File.exist?(output_path)).to be true
          content = File.read(output_path)
          expect(content).to include('data-name="record-number"')
        end
      end
    end

    context 'when given a non-existent file' do
      it 'prints an error message and exits with a non-zero status' do
        stdout, stderr, status = Open3.capture3(executable, 'parse', non_existent_file)
        expect(stdout).to include("Error: File not found at #{non_existent_file}")
        expect(stderr).to be_empty
        expect(status.success?).to be false
      end
    end
  end
end
