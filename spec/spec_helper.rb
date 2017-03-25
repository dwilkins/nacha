require "bundler/setup"
require "nacha"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  config.filter_run_when_matching :focus

  config.when_first_matching_example_defined(:nacha_record_type) do
    @loader = Nacha::Loader.new  # Load those classes
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
