$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "skip_activerecord_callbacks/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "skip_activerecord_callbacks"
  s.version     = SkipActiverecordCallbacks::VERSION
  s.authors     = ["Donald Ball"]
  s.email       = ["donald.ball@gmail.com"]
  s.homepage    = "http://github.com/dball/skip_activerecord_callbacks"
  s.summary     = "Lets you save activerecord models without callbacks"
  s.description = "Provides support for the deprecated update_without_callbacks method from rails 2"

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "minitest"
end
