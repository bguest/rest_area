module RestArea
  class RestController < ApplicationController
    skip_before_filter :verify_authenticity_token
    before_filter :get_class

    # GET
    def index
      render json:{ @roots => @klass.all(query_params) }.to_json(root:false)
    end

    def show
      render json: @klass.find(params[:id]).to_json(:root => @root), :status => :ok
    end
    alias_method :edit, :show

    # POST
    def create
      object = @klass.new(params[@root.to_sym])
      if object.save
        render json: object.to_json(:root => @root), :status => :created
      else
        render_errors(object)
      end
    end

    # PUT
    def update
      object = @klass.find(params[:id])
      if object.update_attributes(params[@root.to_sym])
        render json: object.to_json(:root => @root), :status => :ok
      else
        render_errors(object)
      end
    end

    # DELETE
    def delete
      object = @klass.find(params[:id])
      if object.destroy
        render json: object.to_json(:root => @root), :status => :ok
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

    def get_class
      @klass = params[:klass].singularize.camelize.constantize
      unless [Thing].include? @klass
        raise ActionController::RoutingError.new("Resource Does Not Exist")
      end

      @roots = ActionController::Base.helpers.sanitize(params[:klass])
      @root = @roots.singularize
    end

  end
end
