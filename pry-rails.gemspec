# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'pry-rails/version'

Gem::Specification.new do |s|
  s.name        = 'pry-rails'
  s.version     = PryRails::VERSION
  s.authors     = ['Robin Wenglewski']
  s.email       = ['robin@wenglewski.de']
  s.homepage    = 'https://github.com/rweng/pry-rails'
  s.summary     = 'Use Pry as your rails console'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.3'
  # s.description = %q{TODO: Write a gem description}

  # s.rubyforge_project = "pry-rails"

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'pry', '>= 0.13.0'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'minitest'
  s.metadata['rubygems_mfa_required'] = 'true'
end
