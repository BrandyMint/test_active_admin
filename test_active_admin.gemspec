# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'test_active_admin/version'

Gem::Specification.new do |gem|
  gem.name          = "test_active_admin"
  gem.version       = TestActiveAdmin::VERSION
  gem.authors       = ["Sergey Semyonov"]
  gem.email         = ["slike982@gmail.com"]
  gem.description   = %q{Test Active Admin in your application}
  gem.summary       = gem.description
  gem.homepage      = "http://github.com/BrandyMint"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"
  gem.add_dependency "factory_girl"
  gem.add_dependency "capybara"
  gem.add_dependency "rspec"
end
