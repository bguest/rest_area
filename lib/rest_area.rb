require "rest_area/engine"
require 'rest_area/resource'
require 'rest_area/configuration'
require 'api-pagination'
require 'ransack'

module RestArea
  mattr_reader :class_whitelist

  class << self

    def config
      @config ||= RestArea::Configuration.new
    end

    def configure(&block)
      self.config.instance_eval(&block) if block_given?
    end

    def resources
      self.config.resources
    end

    def class_whitelist=(array)
      resources.clear
      array.each do |klass|
        self.config.resource klass.name.underscore.to_sym
      end
    end
  end
end
