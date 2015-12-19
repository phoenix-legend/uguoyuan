class AddIndexToRegions < ActiveRecord::Migration
  def change
    add_index(:car_insurance_prices, [:city_name, :car_price], name: 'index_city_name_car_price')
    add_index(:ip_regions, :ip, name: 'index_ip')
  end
end
