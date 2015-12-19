class AddReturnPageToProduct < ActiveRecord::Migration
  def change
    add_column :products, :return_page, :string, :limit => 30
  end
end
