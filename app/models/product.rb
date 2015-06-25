class Product < ActiveRecord::Base
  has_and_belongs_to_many :categories
  attr_accessible :brand, :color, :image, :name
  
  
  
  def self.unique_brands
    conn = ActiveRecord::Base.connection
    conn.execute("select distinct brand from products order by brand").to_a.flatten
  end
  
  
  def self.find_brand_from_free_text(text)
    conn = ActiveRecord::Base.connection
    conn.execute("SELECT distinct brand FROM products WHERE LOWER('#{text}') LIKE CONCAT('%', LOWER(brand), '%');").to_a.flatten
  end   
end
