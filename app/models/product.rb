class Product < ActiveRecord::Base
  has_and_belongs_to_many :categories
  attr_accessible :brand, :color, :image, :name
  
  
  
  def self.unique_brands
    conn = ActiveRecord::Base.connection
    conn.execute("select distinct brand from products order by brand").to_a.flatten
  end   
end
