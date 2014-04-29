$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rest_area/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rest_area"
  s.version     = RestArea::VERSION
  s.authors     = ["Benjamin Guest"]
  s.email       = ["benguest@gmail.com"]
  s.homepage    = "https://github.com/bguest/rest_area"
  s.summary     = "Adds a restfull controller and api to a Rails Application"
  s.description = "RestArea adds a restfull controller and api to any Rails Application, simply add the gem and whitelist of available models"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~>4.1"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'rspec-rails', '~>3.0.0.beta'
  s.add_development_dependency 'mocha', '~>1.0.0'
  s.add_development_dependency 'combustion', '~>0.5.1'
  s.add_development_dependency "sqlite3", '~>1.3'
end
