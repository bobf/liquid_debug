# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'liquid_debug/version'
require 'rspec/its'

Gem::Specification.new do |spec|
  spec.name          = 'liquid_debug'
  spec.version       = LiquidDebug::VERSION
  spec.authors       = ['Bob Farrell']
  spec.email         = ['git@gmail.com']

  spec.summary       = "Debug Shopify's Liquid templating language"
  spec.description   = 'Extends Liquid for enhanced debugging'
  spec.homepage      = 'https://github.com/bobf/liquid_debug'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.required_ruby_version = '>= 2.6'

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'liquid', '~> 5.3'
  spec.add_runtime_dependency 'paint', '~> 2.1'

  spec.add_development_dependency 'betterp', '~> 0.1.6'
  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.11'
  spec.add_development_dependency 'rspec-its', '~> 1.3'
  spec.add_development_dependency 'rubocop', '~> 1.29'
  spec.add_development_dependency 'rubocop-performance', '~> 1.13'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.11'
  spec.add_development_dependency 'strong_versions', '~> 0.4.5'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
