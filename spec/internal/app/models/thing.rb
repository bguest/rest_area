class Thing < ActiveRecord::Base
  serialize :array, Array
end

