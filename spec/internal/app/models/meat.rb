# NOTE: Meat is not in the class whitelist and not accessable through the API

class Meat < ActiveRecord::Base
  belongs_to :supermarket
end
