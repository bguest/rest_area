require 'saneitized'

module RestArea
  class RestController < ApplicationController
    skip_before_filter :verify_authenticity_token
    include GetsKlass
    before_filter :test_action
    before_filter :set_class_serializer
    before_filter :add_headers
    before_filter :add_query_params, :only => [:index]

    # GET
    def index
      if @serializer
        render json: @klass.all, each_serializer: @serializer, root:@roots
      else
        render json:{ @roots => @klass.all }.to_json(root:false)
      end
    end

    def show
      render json: @resource.find(params[:id]), root: @root
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
      object = @resource.find(params[:id])
      if object.update_attributes(params[@root.to_sym])
        render json: object, root:@root
      else
        render_errors(object)
      end
    end

    # DELETE
    def delete
      object = @resource.find(params[:id])
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

    def test_action
      unless @resource.can_do?(params[:action].to_sym)
        raise ActionController::RoutingError.new("Resource Does Not Exist")
      end
    end

    def klass_params
      params.require(@root.to_sym).permit!
    end

    def add_headers
      response.headers.merge! @resource.headers
    end

    def add_query_params
      where_params = params.slice(*@klass.column_names)
      if where_params.any?
        @klass = @klass.where(where_params)
      end
    end

    def set_class_serializer
      @serializer = ( '::' + @klass.to_s + "Serializer" ).constantize
    rescue NameError => e
      unless e.message =~ /uninitialized constant/
        throw e
      end
    end

  end
end
