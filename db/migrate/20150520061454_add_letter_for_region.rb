class AddLetterForRegion < ActiveRecord::Migration
  def change
    add_column :regions, :first_letter, :string, :limit => 2
    add_column :products, :server_name, :string, :limit => 10
  end
end
