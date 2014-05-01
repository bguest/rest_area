ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'bundler/setup'

require 'combustion'
Combustion.initialize! :active_record, :action_controller
require 'rspec/rails'

RSpec.configure do |config|
  config.add_setting :updating_rails_version
  config.updating_rails_version = false
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :mocha
  config.use_transactional_fixtures = true
  config.order = "random"
end