# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-dictionary/version'

Gem::Specification.new do |gem|
  gem.name          = 'ruby-dictionary'
  gem.version       = Dictionary::VERSION
  gem.authors       = ['Matt Huggins']
  gem.email         = ['matt.huggins@gmail.com']
  gem.description   = %q{Dictionary class for ruby that allows for checking
                         existence and finding words starting with a given
                         prefix.}
  gem.summary       = 'Simple dictionary class for checking existence of words'
  gem.homepage      = 'https://github.com/mhuggins/ruby-dictionary'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
