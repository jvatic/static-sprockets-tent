# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'static-sprockets-tent/version'

Gem::Specification.new do |gem|
  gem.name          = "static-sprockets-tent"
  gem.version       = StaticSprocketsTent::VERSION
  gem.authors       = ["Jesse Stuart"]
  gem.email         = ["jesse@jessestuart.ca"]
  gem.description   = %q{Adds Tent authentication to static-sprockets}
  gem.summary       = %q{Adds Tent authentication to static-sprockets}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'static-sprockets'
  gem.add_runtime_dependency 'omniauth-tent'
  gem.add_runtime_dependency 'tent-client'
  gem.add_runtime_dependency 'yajl-ruby'
end
