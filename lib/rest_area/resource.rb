module RestArea
  class Resource

    attr_reader :actions, :klass

    def initialize(klss)
      @actions = []
      @klass = klss.to_s.classify.constantize
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
      if klass.method_defined? msg
        @messages << msg
        @messages.uniq!
      else
        raise NoMethodError.new("#{klass} will not respond to #{msg}")
      end
    end

    def headers(hdrs = nil)
      @headers ||= {}
      if hdrs
        @headers.merge! hdrs
      else
        @headers.inject({}){ |hash, (key, value)|
          value = value.call if value.kind_of? Proc
          hash.merge(key => value)
        }
      end
    end
    alias_method :headers=, :headers

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
        klass.find(*args)
      else
        klass.where(key => args[0]).first!
      end
    end

  end
end
