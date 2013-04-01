# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'outpost/asset_host/version'

Gem::Specification.new do |spec|
  spec.name          = "outpost-asset_host"
  spec.version       = Outpost::AssetHost::VERSION
  spec.authors       = ["Bryan Ricker"]
  spec.email         = ["bricker88@gmail.com"]
  spec.description   = %q{AssetHost integration with Outpost.}
  spec.summary       = %q{AssetHost integration with Outpost.}
  spec.homepage      = "https://github.com/SCPR/outpost-asset_host"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
