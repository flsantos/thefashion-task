class ProductsController < ApplicationController
  def index
    
    @brands = Product.unique_brands
    @categories = Category.categories_list
                                
  end
  
  def search
    @products = [] 
    if !params[:description].empty?
        @products = find_products_by_free_text(params[:description])
    else
      if !params[:brand].empty? and !params[:category].empty?
        @products = Product.where("brand = ? and category_text like ?", params[:brand], "%#{params[:category]}%")
      else
        @products = Product.where("category_text like ?", "%#{params[:category]}%") if !params[:category].empty?
        @products = Product.where("brand = ?", params[:brand]) if !params[:brand].empty?
      end  
    end
    
    @brand = params[:brand]
    @category = params[:category]
    
    @brands = Product.unique_brands
    @categories = Category.categories_list
    
    render "index"
  end


  helper_method :find_products_by_free_text
  def find_products_by_free_text(text)
    
    name_arg = text.clone
    
    possible_brands = Product.find_brand_from_free_text(text)
    brand_found = possible_brands.first if possible_brands.size == 1
    
    possible_categories = Category.find_category_from_free_text(text)
    category_found = possible_categories.first if possible_categories.size == 1
    
    
    name_arg = name_arg.downcase
    name_arg.slice!(brand_found.downcase) if !brand_found.nil?
    possible_brands.each { |brand| name_arg.slice! brand.downcase} if possible_brands.size > 1
    name_arg.slice!(category_found.downcase) if !category_found.nil? 
    name_arg = name_arg.strip
    
    
    where_clause = ""
    if possible_brands.size > 1
      where_clause += " ( " + possible_brands.collect {|c| " brand = '#{c}' " }.join(" OR ") + " ) "
    else
      where_clause += " brand = '#{brand_found}' " if !brand_found.nil?
    end
    where_clause += " AND " if !brand_found.nil? and !category_found.nil? 
    where_clause += " category_text like '#{Category.find_by_name(category_found).self_and_ascendents_list_string}%' " if !category_found.nil?
    where_clause += " AND " if (!brand_found.nil? or possible_brands.size > 1 or !category_found.nil? ) and !name_arg.empty?
    where_clause += " ( " + name_arg.split(" ").collect {|word| " name like '%#{word}%' "}.join(" AND ") + " ) " if name_arg.split(" ").size > 0
     
    
    Product.where(where_clause)
  end

end
