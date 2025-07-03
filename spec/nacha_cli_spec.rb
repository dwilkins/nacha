require 'spec_helper'
require 'open3' # For capturing stdout/stderr

RSpec.describe 'Nacha CLI', type: :aruba do
  let(:executable) { File.expand_path('../exe/nacha', __dir__) }
  let(:valid_ach_file) { File.expand_path('fixtures/achfiles/ppd_valid_1.txt', __dir__) }
  let(:non_existent_file) { 'non_existent_file.ach' }

  describe 'parse command' do
    context 'when given a valid ACH file' do
      it 'parses the file and prints a success message' do
        stdout, stderr, status = Open3.capture3(executable, 'parse', valid_ach_file)
        expect(stderr).to be_empty
        expect(stdout).to include("Successfully parsed #{valid_ach_file}")
        expect(stdout).to include("data-name=\"record-number\"")
        expect(status.success?).to be true
      end
    end

    context 'when given a non-existent file' do
      it 'prints an error message and exits with a non-zero status' do
        stdout, stderr, status = Open3.capture3(executable, 'parse', non_existent_file)
        expect(stdout).to include("Error: File not found at #{non_existent_file}")
        expect(stderr).to be_empty # Thor usually sends errors to stdout
        expect(status.success?).to be false
      end
    end

    # Helper to run the command
    def run_command(*args)
      Open3.capture3(executable, *args)
    end
  end
end
