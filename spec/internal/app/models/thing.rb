class Thing < ActiveRecord::Base
  serialize :array, Array

  belongs_to :cereal
end

