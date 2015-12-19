class AddCarNumberPrefixToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :car_number_prefix, :string
  end
end
