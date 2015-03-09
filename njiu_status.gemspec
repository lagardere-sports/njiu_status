# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'njiu_status/version'

Gem::Specification.new do |spec|
  spec.name          = "njiu_status"
  spec.version       = NjiuStatus::VERSION
  spec.authors       = ["Raik Osiablo"]
  spec.email         = ["raik.osiablo@njiuko.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "byebug"
end
