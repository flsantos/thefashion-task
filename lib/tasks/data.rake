# encoding: UTF-8
namespace :data do
  
  def find_or_create(category, level)
    c = Category.find_by_name(category)
    if c == nil
      c = Category.new
      c.name=category
      c.level = level
      c.save!
    end
    return c
  end
  
  def parse_category(category)
    categories = category.split("/")
    previous = ""
    last_cat = ""
    level = 0
    categories.each do |subc|
      c = find_or_create(subc.strip, level)
      if !previous.empty?
        aux = find_or_create(previous.strip, level)
        c.parent_category=aux
        aux.subcategories << c
      end
      level = level + 1
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
      p.name = attrs[0].strip
      p.brand = attrs[1].strip
      p.categories = categories
      p.category_text = attrs[2].strip
      p.color = attrs[3].strip
      p.image = attrs[4].strip
      p.save!
      
    end
  end
end