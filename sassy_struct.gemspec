# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sassy_struct/version'

Gem::Specification.new do |spec|
  spec.name          = "sassy_struct"
  spec.version       = SassyStruct::VERSION
  spec.authors       = ["Michael Gee", "Mark Lorenz"]
  spec.email         = ["michaelpgee@gmail.com", "mlorenz@covermymeds.com"]
  spec.description   = %q{More sass in more structs.}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-plus"
end
