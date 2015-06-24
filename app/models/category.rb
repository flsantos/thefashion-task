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
end
