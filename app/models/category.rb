class Category < ActiveRecord::Base
  attr_accessible :name, :level
  has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_category, :class_name => "Category", :foreign_key => "parent_id"
  has_and_belongs_to_many :products
  
  
  def self_and_ascendents_list_string
    if parent_category == nil or level == 0
      return name
    else
      return "#{parent_category.self_and_ascendents_list_string}/#{name}"
    end
  end
  
  def descendents
    subcategories.map do |subcategory|
      [subcategory] + subcategory.descendents
    end.flatten
  end

  def self_and_descendents
    [self] + descendents
  end
  
  def self.categories_list
    conn = ActiveRecord::Base.connection
=begin
 select node.name as node_name 
     , up1.name as up1_name 
     , up2.name as up2_name 
     , concat_ws("/", up2.name,up1.name,node.name) as category
  from categories as node
left outer 
  join categories as up1 
    on up1.id = node.parent_id  
left outer 
  join categories as up2
    on up2.id = up1.parent_id 
order
    by up2_name,up1_name, node_name 
=end    

    conn.execute("select concat_ws('/',up2.name,up1.name,node.name) as category 
                                from categories as node 
                                left outer join categories as up1 on up1.id = node.parent_id 
                                left outer join categories as up2 on up2.id = up1.parent_id and up1.name != up2.name
                                order by up2.name,up1.name,node.name")
                                .to_a.flatten  
  end
  
  
  
  
  def self.find_category_from_free_text(text)
    conn = ActiveRecord::Base.connection
    conn.execute("SELECT name FROM categories WHERE LOWER('#{text}') LIKE CONCAT('%', LOWER(name), '%') ORDER BY level LIMIT 1;").to_a.flatten
  end
end
