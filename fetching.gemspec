lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fetching/version'

Gem::Specification.new do |spec|
  spec.name          = 'fetching'
  spec.version       = Fetching::VERSION
  spec.authors       = ['Michael Gee', 'Mark Lorenz']
  spec.email         = ['mgee@covermymeds.com', 'mlorenz@covermymeds.com']
  spec.description   = "Strict wrapper for Hashes and Arrays that doesn't return nil"

  spec.summary       = <<-HEREDOC
Don't de-serialize API responses in to hashes and arrays.
Use a "strict" object that inforces key presence and array bounds.
  HEREDOC

  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rubocop', '~> 0.58.0'
  spec.add_development_dependency 'rubocop-rspec'
  unless ENV['CI']
    spec.add_development_dependency 'guard-rspec'
    spec.add_development_dependency 'guard-rubocop'
    spec.add_development_dependency 'pry'
  end
end
