module GetsKlass
  extend ActiveSupport::Concern

  included do
    before_filter :get_klass
  end

  def get_klass
    rescue_uninitialized_constant do
      klass = params[:klass].classify.constantize
      @klass = RestArea.resources[klass.name.underscore.to_sym]
    end
    test_class(@klass)

    @roots = ActionController::Base.helpers.sanitize(params[:klass]).pluralize
    @root = @roots.singularize
  end

  def test_class(klass)
    if klass.nil? || !RestArea.resources.include?(klass.name.underscore.to_sym)
      raise ActionController::RoutingError.new("Resource Does Not Exist")
    end
  end

end
