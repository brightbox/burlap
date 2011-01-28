# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "brappa/version"

Gem::Specification.new do |s|
  s.name        = "brappa"
  s.version     = Brappa::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Caius Durling"]
  s.email       = ["hello@brightbox.co.uk"]
  s.homepage    = ""
  s.summary     = %q{Wrapper for burlap APIs}
  s.description = %q{Translates responses from Burlap APIs to ruby, and generates requests to send back.}

  s.rubyforge_project = "brappa"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "nokogiri", "~> 1.4.4"
end
