# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pry-rails/version"

Gem::Specification.new do |s|
  s.name        = "pry-rails"
  s.version     = PryRails::VERSION
  s.authors     = ["Robin Wenglewski"]
  s.email       = ["robin@wenglewski.de"]
  s.homepage    = ""
  s.summary     = %q{Use Pry as your rails console}
  # s.description = %q{TODO: Write a gem description}

  # s.rubyforge_project = "pry-rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency "pry"
end
