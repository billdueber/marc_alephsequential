# -*- encoding: utf-8 -*-

require File.expand_path('../lib/marc_alephsequential/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "marc_alephsequential"
  gem.version       = MarcAlephsequential::VERSION
  gem.summary       = %q{ruby-marc reader for Aleph sequential files}
  gem.description   = %q{A ruby-marc reader for Aleph sequential files, a MARC serialization supported by Ex Libris' Aleph}
  gem.license       = "MIT"
  gem.authors       = ["Bill Dueber"]
  gem.email         = "bill@dueber.com"
  gem.homepage      = "https://github.com/billdueber/marc_alephsequential#readme"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'yard', '~> 0.8'
end
