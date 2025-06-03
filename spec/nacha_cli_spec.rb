require 'spec_helper'
require 'open3' # For capturing stdout/stderr

RSpec.describe 'Nacha CLI', type: :aruba do
  let(:executable) { File.expand_path('../../../bin/nacha', __FILE__) } # Adjust path as needed
  let(:valid_ach_file) { File.expand_path('../../fixtures/achfiles/ppd_valid_1.txt', __FILE__) }
  let(:non_existent_file) { 'non_existent_file.ach' }

  describe 'parse command' do
    context 'when given a valid ACH file' do
      it 'parses the file and prints a success message' do
        stdout, stderr, status = Open3.capture3(executable, 'parse', valid_ach_file)
        expect(stderr).to be_empty
        expect(stdout).to include("Successfully parsed #{valid_ach_file}")
        expect(stdout).to include("Record #1:") # Basic check for record output
        expect(status.success?).to be true
      end

      it 'prints information about the records' do
        stdout, stderr, status = Open3.capture3(executable, 'parse', valid_ach_file)
        expect(stderr).to be_empty
        # Add more specific expectations about the output format if known
        # For example, if records are expected to show specific fields:
        # expect(stdout).to include("SomeExpectedField: SomeValue")
        expect(stdout).to match(/Record #\d+:/)
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

    context 'when given an invalid ACH file (e.g., empty or malformed)' do
      let(:invalid_ach_file) { File.expand_path('../../fixtures/achfiles/ccd_invalid_3.txt', __FILE__) } # Assuming this is invalid for parsing
      let(:empty_ach_file) { File.expand_path('../../fixtures/achfiles/empty_file.txt', __FILE__) }

      before do
        # Create an empty file for testing
        FileUtils.touch(empty_ach_file)
      end

      after do
        # Clean up the empty file
        FileUtils.rm(empty_ach_file, force: true)
      end

      it 'handles an empty file gracefully' do
        stdout, stderr, status = Open3.capture3(executable, 'parse', empty_ach_file)
        expect(stderr).to be_empty
        expect(stdout).to include("Could not parse the file or the file was empty")
        # Depending on implementation, exit status might be success or failure for empty files.
        # If it's considered an error:
        # expect(status.success?).to be false
        # If it's not an error but just no data:
        expect(status.success?).to be true # Current impl seems to exit 0 for this
      end

      # This test depends on Nacha.parse raising an error for ccd_invalid_3.txt
      # or the CLI handling it as a parse failure.
      it 'handles a malformed ACH file' do
        # The current Nacha.parse might not raise errors for all invalid structures,
        # but rather return a partially parsed object or an empty array.
        # The CLI currently prints "Could not parse..." for such cases or an error.
        stdout, stderr, status = Open3.capture3(executable, 'parse', invalid_ach_file)

        # Check if it prints a generic parse error or specific error
        # This expectation might need adjustment based on actual behavior of Nacha.parse
        # with ccd_invalid_3.txt
        expect(stdout).to satisfy { |s| s.include?("An error occurred during parsing") || s.include?("Could not parse the file") }

        # If Nacha.parse raises an error that the CLI catches and exits(1):
        # expect(status.success?).to be false
        # If Nacha.parse returns something that the CLI deems "not parseable" and exits(0) or exits(1):
        # Adjust based on actual behavior. The current CLI tries to catch StandardError and exit 1.
        expect(status.success?).to be false
      end
    end

    # Helper to run the command
    def run_command(*args)
      Open3.capture3(executable, *args)
    end
  end
end
