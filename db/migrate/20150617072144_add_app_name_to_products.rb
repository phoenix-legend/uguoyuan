class AddAppNameToProducts < ActiveRecord::Migration
  def change
    add_column :products, :android_app_url, :string, :limit => 300

    add_column :products, :iphone_app_url, :string, :limit => 300

    add_column :products, :sale_number, :integer

    add_column :products, :price, :integer
  end
end
