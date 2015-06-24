class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.references :parent

      t.timestamps
    end
    add_index :categories, :parent_id
  end
end
