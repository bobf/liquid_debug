# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'liquid_debug/version'
require 'rspec/its'

Gem::Specification.new do |spec|
  spec.name          = 'liquid_debug'
  spec.version       = LiquidDebug::VERSION
  spec.authors       = ['Bob Farrell']
  spec.email         = ['git@bob.frl']
  spec.licenses      = ['MIT']

  spec.summary       = "Debug Shopify's Liquid templating language"
  spec.description   = 'Extends Liquid for enhanced debugging'
  spec.homepage      = 'https://github.com/bobf/liquid_debug'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.required_ruby_version = '>= 2.7'

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'liquid', '~> 5.3'
  spec.add_runtime_dependency 'paint', '~> 2.1'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
