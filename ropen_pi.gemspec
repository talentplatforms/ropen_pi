lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ropen_pi/version"

Gem::Specification.new do |spec|
  spec.name          = "ropen_pi"
  spec.version       = RopenPi::VERSION
  spec.authors       = ["Andy Ruck"]
  spec.email         = ["devops@talentplatforms.net"]

  spec.summary       = 'Integration of OpenAPI v3 and RSPEC'
  spec.description   = 'Integrates OpenAPI v3 with RSPEC and automates the output of the open api document'
  spec.homepage      = "https://github.com/talentplatforms/ropen_pi"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "bump"
  spec.add_development_dependency "rails", "~> 6.0"

  #
  # spec.add_runtime_dependency "dry_open_api", "~> 0.1.1"
  spec.add_runtime_dependency "hashie"
  spec.add_runtime_dependency "json-schema"
end
