class Thing < ActiveRecord::Base
  serialize :array, Array

  belongs_to :cereal

  def say_hello
    'hello world'
  end

  def say_goodbye
    'goodbye cruel world'
  end
end

