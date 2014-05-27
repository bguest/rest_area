module RestArea
  class RestController < ApplicationController
    skip_before_filter :verify_authenticity_token
    before_filter :get_class, :set_class_serializer

    # GET
    def index
      if @serializer
        render json: @klass.all, each_serializer: @serializer, root:@roots
      else
        render json:{ @roots => @klass.all }.to_json(root:false)
      end
    end

    def show
      render json: @klass.find(params[:id]), root: @root
    end
    alias_method :edit, :show

    # POST
    def create
      object = @klass.new(params[@root.to_sym])
      if object.save
        render json: object, root:@root
      else
        render_errors(object)
      end
    end

    # PUT
    def update
      object = @klass.find(params[:id])
      if object.update_attributes(params[@root.to_sym])
        render json: object, root:@root
      else
        render_errors(object)
      end
    end

    # DELETE
    def delete
      object = @klass.find(params[:id])
      if object.destroy
        render json: object, root:@root
      else
        render_errors(object)
      end
    end

    private

    def render_errors(object)
      render json: {errors: object.errors}, :status => :unprocessable_entity
    end

    def query_params
      params.slice('limit','order').symbolize_keys
    end

    def set_class_serializer
      @serializer = ( '::' + @klass.to_s + "Serializer" ).constantize
    rescue NameError => e
      if e.message =~ /uninitialized constant/
        @serializer = false
      else
        throw e
      end
    end

    def get_class
      @klass = params[:klass].singularize.camelize.constantize
      unless RestArea.class_whitelist.include? @klass
        raise ActionController::RoutingError.new("Resource Does Not Exist")
      end

      @roots = ActionController::Base.helpers.sanitize(params[:klass]).pluralize
      @root = @roots.singularize
    end

  end
end
