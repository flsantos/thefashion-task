class Category < ActiveRecord::Base
  attr_accessible :name
  has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_category, :class_name => "Category", :foreign_key => "parent_id"
  has_and_belongs_to_many :products
  
  
  def descendents
    subcategories.map do |subcategory|
      [subcategory] + subcategory.descendents
    end.flatten
  end

  def self_and_descendents
    [self] + descendents
  end
  
end
