class AddCategoriesTextToProducts < ActiveRecord::Migration
  def change
    add_column :products, :category_text, :string
  end
end
