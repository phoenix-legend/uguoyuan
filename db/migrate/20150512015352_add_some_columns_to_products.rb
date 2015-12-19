class AddSomeColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :description, :string
    add_column :products, :cover_image, :string
    add_column :products, :url, :string
  end
end
