class ProductsController < ApplicationController
  def index
    
    @brands = Product.unique_brands
    @categories = Category.categories_list
                                
  end

  def new
    @product = Product.new
  end
  
  
  def search
    @products = [] 
    if !params[:brand].empty? and !params[:category].empty?
      @products = Product.where("brand = ? and category_text like ?", params[:brand], "%#{params[:category]}%")
    else
      @products = Product.where("category_text like ?", "%#{params[:category]}%") if !params[:category].empty?
      @products = Product.where("brand = ?", params[:brand]) if !params[:brand].empty?
    end
    @brand = params[:brand]
    @category = params[:category]
    
    @brands = Product.unique_brands
    @categories = Category.categories_list
    
    render "index"
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to products_url, :notice => "Successfully created product."
    else
      render :action => 'new'
    end
  end
end
