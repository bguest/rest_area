class Supermarket < ActiveRecord::Base
  has_many :meats
  has_many :cereals

  def ring_it_up
    {:calories => cereals.sum(&:calories)}
  end
end
