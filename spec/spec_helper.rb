ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'bundler/setup'

require 'combustion'
puts 'combusting'
Combustion.initialize! :active_record, :action_controller
puts 'done'
require 'rspec/rails'

RSpec.configure do |config|
  config.mock_with :mocha
  config.use_transactional_fixtures = true
  config.order = "random"
end
