##
# Used for configuring rest_area
#
# RestArea.config do
#   resources :cereal, :thing do
#     action :index, :show, :create, :update, :delete
#   end
#
#   resource :supermarket do
#     read_only!
#     key :name
#   end
# end
#
module RestArea
  class Configuration

    def initialize()
      @resources = {}
    end

    def resources(*args, &block)
      if args.any?
        args.each do |klass| resource(klass, &block) end
      else
        @resources
      end
    end

    def resource(klass, &block)
      resource = Resource.new(klass)
      resource.instance_eval(&block) if block_given?
      @resources[klass] = resource
    end
  end

end
