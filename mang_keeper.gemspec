# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mang_keeper/version"

Gem::Specification.new do |s|
  s.name        = "mang_keeper"
  s.version     = MangKeeper::VERSION
  s.authors     = ["MOZGIII"]
  s.email       = ["mike-n@narod.ru"]
  s.homepage    = "http://github.com/MOZGIII/MaNGOS-Keeper"
  s.summary     = %q{MaNGOS Keeper}
  s.description = %q{Helps to maintain MaNGOS server.}

  s.rubyforge_project = "mang_keeper"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
