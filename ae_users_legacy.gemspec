# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.version       = "0.6.10"

  gem.authors       = ["Nat Budin"]
  gem.email         = ["natbudin@gmail.com"]
  gem.description   = %q{Don't use this gem.  Use something written in the last couple years instead.}
  gem.summary       = %q{An obsolete authentication and authorization system which you shouldn't use.}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ae_users_legacy"
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  gem.add_runtime_dependency(%q<ruby-openid>, [">= 2.0.4"])
end
