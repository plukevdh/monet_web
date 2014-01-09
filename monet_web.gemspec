# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'monet_web/version'

Gem::Specification.new do |spec|
  spec.name          = "monet_web"
  spec.version       = MonetWeb::VERSION
  spec.authors       = ["Luke van der Hoeven"]
  spec.email         = ["hungerandthirst@gmail.com"]
  spec.summary       = %q{MonetWeb: A web interface/diff viewer for the Monet gem}
  spec.description   = %q{Monet is a image capture/diff gem. MonetWeb gives Monet an interface to do comparisons and capture runs.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency 'sinatra-asset-pipeline'
  spec.add_dependency "monet"
  spec.add_dependency "redis"
  spec.add_dependency "sidekiq"

  spec.add_development_dependency "bundler", "~> 1.4"
  spec.add_development_dependency "rake"
end
