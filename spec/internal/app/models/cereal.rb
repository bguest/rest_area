class Cereal < ActiveRecord::Base
  belongs_to :supermarket
  has_many :things
end
