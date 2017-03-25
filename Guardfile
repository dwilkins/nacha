# More info at https://github.com/guard/guard#readme
guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # Feel free to open issues for suggestions and improvements

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)
  watch(%r{^lib/nacha/base_record\.rb} )        { |m| Dir.glob('spec/nacha/record_types/*_spec.rb') }
  watch(%r{^lib/config/definitions/(.+)\.yml} ) { |m| "spec/nacha/record_types/#{m[1]}_spec.rb" }
  #     watch(%r{^app/(.+)\.rb$})                               { |m| "test/#{m[1]}_test.rb" }

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

end
