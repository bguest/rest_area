module RestArea
  class ApplicationController < ::ApplicationController 

    private

    def rescue_uninitialized_constant
      yield
    rescue NameError => e
      unless e.message =~ /uninitialized constant/
        throw e
      end
    end

    def search(relation)
      conditions = {}
      Hash(params[:q]).each do |attr, term|
        conditions["#{attr}_cont"] = term
      end
      conditions[:m] = 'or'
      relation.ransack(conditions).result
    end

    def order(relation)
      order_by = Array(params[:sort]).collect do |attr|
        case attr[0]
        when '-'
          "#{attr[1..-1]} DESC"
        else
          "#{attr} ASC"
        end
      end

      unless order_by.empty?
        relation.order(order_by.join(','))
      else
        relation
      end
    end

  end

end
