class AddAppNameToProduct < ActiveRecord::Migration
  def change
    add_column :products, :app_name, :string
  end
end
