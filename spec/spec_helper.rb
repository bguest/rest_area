require 'simplecov'
SimpleCov.start 'rails'
ENV["RAILS_ENV"] ||= 'test'

require 'coveralls'
Coveralls.wear!

require 'rubygems'
require 'bundler/setup'

require 'combustion'
Combustion.initialize! :active_record, :action_controller
require 'rspec/rails'
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.add_setting :updating_rails_version
  config.updating_rails_version = false
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :mocha
  config.use_transactional_fixtures = true
  config.order = "random"
end
