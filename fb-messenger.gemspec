# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fb/messenger/version'

Gem::Specification.new do |spec|
  spec.name          = "fb-messenger"
  spec.version       = Fb::Messenger::VERSION
  spec.authors       = ["ccleung"]
  spec.email         = ["clemsquared@gmail.com"]

  spec.summary       = %q{Send and receive Facebook messenger messages.}
  spec.description   = %q{Send and receive Facebook messenger messages using the Facebook messenger API.}
  spec.homepage      = "https://github.com/ccleung/fb-messenger"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 1.8"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "factory_girl", "~> 4.7"
  spec.add_development_dependency "webmock", "~> 2.1"
end
