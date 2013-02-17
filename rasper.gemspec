# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rasper/version'

Gem::Specification.new do |gem|
  gem.name          = "rasper"
  gem.version       = Rasper::VERSION
  gem.authors       = ["Rodrigo Manhães"]
  gem.email         = ["rmanhaes@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.platform      = 'java'

  gem.add_dependency 'builder'
  gem.add_dependency 'activesupport'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'docsplit'
end