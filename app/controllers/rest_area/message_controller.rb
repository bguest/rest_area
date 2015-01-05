module RestArea
  class MessageController < ApplicationController
    include GetsKlass
    before_filter :get_message, :set_message_class, :set_message_serializer

    def get
      if @message_serializer
        render json: @resource.find(params[:id]).send(@message).all, each_serializer: @message_serializer, root:@message
      elsif @message_class
        render json: { @message => @resource.find(params[:id]).send(@message).all }.to_json(root:false)
      elsif @resource.can_send?(@message)
        render json: @resource.find(params[:id]).send(@message).to_json(root:false)
      else
        raise ActionController::RoutingError.new("Resource Does Not Exist")
      end
    end

    private

    def get_message
      @message = params[:message]
    end

    def set_message_class
      rescue_uninitialized_constant do
        @message_class = @message.classify.constantize
      end
      test_class(@message_class) if @message_class
    end

    def set_message_serializer
      return unless @message_class
      rescue_uninitialized_constant do
        @message_serializer = ( '::' + @message.classify + "Serializer" ).constantize
      end
    end
  end
end
