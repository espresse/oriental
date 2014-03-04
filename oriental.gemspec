# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oriental/version'

Gem::Specification.new do |spec|
  spec.name          = "oriental"
  spec.version       = Oriental::VERSION
  spec.authors       = ["Michal Ostrowski"]
  spec.email         = ["ostrowski.michal@gmail.com"]
  spec.summary       = %q{SQL builder for OrientDB written in Ruby}
  spec.description   = %q{SQL builder for OrientDB, uses orient_binary gem}
  spec.homepage      = "https://github.com/espresse/oriental"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", '~> 0.9'
  spec.add_development_dependency "orientdb-binary", '~> 0.8'
  spec.add_development_dependency "veto", "~> 1.0"
  spec.add_development_dependency "virtus", "~> 1.0"
  spec.add_development_dependency "simplecov", '~> 0.8'
  spec.add_development_dependency "active_support", '~> 3.0'
  spec.add_development_dependency "rack-test", '~> 0.6'
  spec.add_development_dependency "i18n", '~> 0.6'

end
