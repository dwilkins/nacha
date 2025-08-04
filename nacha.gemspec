# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nacha/version'

Gem::Specification.new do |spec|
  spec.name          = "nacha"
  spec.version       = Nacha::VERSION
  spec.authors       = ["David H. Wilkins"]
  spec.email         = ["dwilkins@conecuh.com"]

  spec.summary       = %q(Ruby parser for ACH files.)
  spec.description   = %q(Ruby parser for ACH files.)
  spec.homepage      = 'https://github.com/dwilkins/nacha'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.2.8'

  spec.metadata = {
    'documentation_uri' => 'https://dwilkins.github.io/nacha/doc',
    'source_code_uri' => spec.homepage
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'bigdecimal'
  spec.add_dependency 'httparty'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug' if RUBY_ENGINE == 'ruby'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'gitlab-styles'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-nav' if RUBY_ENGINE == 'jruby'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-lcov'
  spec.add_development_dependency 'yard'
end
