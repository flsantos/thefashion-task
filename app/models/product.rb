class Product < ActiveRecord::Base
  has_and_belongs_to_many :categories
  attr_accessible :brand, :color, :image, :name
end