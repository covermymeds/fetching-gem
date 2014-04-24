# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fetching/version'

Gem::Specification.new do |spec|
  spec.name          = "fetching"
  spec.version       = Fetching::VERSION
  spec.authors       = ["Michael Gee", "Mark Lorenz"]
  spec.email         = ["mgee@covermymeds.com", "mlorenz@covermymeds.com"]
  spec.description   = %q{More sass in more structs.}

  spec.summary       = <<-HEREDOC
This gem is a work in progress.  The implementation code is not what's
important.  What is important: Don't de-serialize API responses in to
hashes and arrays.  Use a "strict" object that inforces key presence,
and array bounds.}
HEREDOC

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
