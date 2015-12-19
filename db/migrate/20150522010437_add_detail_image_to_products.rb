class AddDetailImageToProducts < ActiveRecord::Migration
  def change
    add_column :products, :detail_image, :string
  end
end
