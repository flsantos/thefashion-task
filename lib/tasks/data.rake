# encoding: UTF-8
namespace :data do
  
  def find_or_create(category)
    c = Category.find_by_name(category)
    if c == nil
      c = Category.new
      c.name=category
      c.save!
    end
    return c
  end
  
  def parse_category(category)
    categories = category.split("/")
    previous = ""
    last_cat = ""
    categories.each do |subc|
      c = find_or_create(subc)
      if !previous.empty?
        aux = find_or_create(previous)
        c.parent_category=aux
        aux.subcategories << c
      end
      previous = c.name
      last_cat = c
    end
    return last_cat
  end
  
  task :import => :environment do
    file = File.open("thefashion_test_data.csv")
    file.each do |line|
      #desc line
      
      
      if !line.valid_encoding?
        #line = line.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
        line = line.force_encoding("UTF-8")
      end
      attrs = line.split(";")
      
      
      cat = attrs[2]
      categories = []
      if cat.index("&") != nil
        categories << parse_category(cat.split("&")[0])
        categories << parse_category(cat.split("&")[1])
        
      else
        categories << parse_category(cat)
      end
      p = Product.new
      p.name = attrs[0]
      p.brand = attrs[1]
      p.categories = categories
      p.color = attrs[3]
      p.image = attrs[4]
      p.save!
      
    end
  end
end