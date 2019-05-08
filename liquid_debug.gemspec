# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'liquid_debug/version'

Gem::Specification.new do |spec|
  spec.name          = 'liquid_debug'
  spec.version       = LiquidDebug::VERSION
  spec.authors       = ['Bob Farrell']
  spec.email         = ['robertanthonyfarrell@gmail.com']

  spec.summary       = "Debug Shopify's Liquid templating language"
  spec.description   = 'Extends Liquid for enhanced debugging'
  spec.homepage      = 'https://github.com/bobf/liquid_debug'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.68.1'
  spec.add_development_dependency 'strong_versions', '~> 0.3.2'
end
