# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "transient/version"

Gem::Specification.new do |s|
  s.name        = "transient"
  s.version     = Transient::VERSION
  s.authors     = ["C. Jason Harrelson (midas)"]
  s.email       = ["jason@lookforwardenterprises.com"]
  s.homepage    = "https://github.com/midas/transient"
  s.summary     = %q{}
  s.description = %q{Provides an API for making any ActiveRecord object transient.}

  s.rubyforge_project = "transient"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rails", ">= 3.0.0"
  s.add_development_dependency "ruby-debug"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "guard"
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'growl'
	s.add_development_dependency 'guard-rspec'

  s.add_runtime_dependency "rails", ">= 3.0.0"
end
