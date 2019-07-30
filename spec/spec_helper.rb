require 'bundler/setup'
require 'nacha'
require 'support/factory_bot'
require 'nacha/record/file_header_record_type'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  config.filter_run_when_matching :focus

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.order = :random
end

# Silence output from pending examples in documentation formatter
module FormatterOverrides
  def dump_pending(_); end
end

RSpec::Core::Formatters::DocumentationFormatter.prepend FormatterOverrides

# Silence output from pending examples in progress formatter
RSpec::Core::Formatters::ProgressFormatter.prepend FormatterOverrides
