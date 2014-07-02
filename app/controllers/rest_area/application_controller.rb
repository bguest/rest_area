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
  end

end
