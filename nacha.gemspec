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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "gitlab-styles"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-doc", "~> 0.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", '~> 0.69.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.1.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.22.1'
end
