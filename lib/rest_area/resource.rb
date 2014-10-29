module RestArea
  class Resource < SimpleDelegator

    attr_reader :actions

    def initialize(klass)
      @actions = []
      @klass = klass.to_s.classify.constantize
      super @klass
    end

    def action(*args)
      @actions ||= []
      @actions += args
      @actions.uniq!
    end

    def messages(*args)
      @messages ||= []
      if args.any?
        args.each do |m| message(m) end
      else
        @messages
      end
    end

    def message(msg)
      @messages ||= []
      if @klass.method_defined? msg
        @messages << msg
        @messages.uniq!
      else
        raise NoMethodError.new("#{@klass} will not respond to #{msg}")
      end
    end

    def read_only!
      @actions = [:index, :show]
    end

    def can_do?(act)
      self.actions.empty? || self.actions.include?(act)
    end

    def can_send?(msg)
      self.messages.include?(msg.to_sym)
    end

    def key(key = nil)
      key ? @key = key : (@key || :id)
    end

    # Wrapped Methods
    def find(*args)
      if key == :id
        super *args
      else
        @klass.where(key => args[0]).first!
      end
    end

  end
end
