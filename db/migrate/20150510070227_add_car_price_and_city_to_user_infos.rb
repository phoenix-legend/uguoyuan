class AddCarPriceAndCityToUserInfos < ActiveRecord::Migration
  def change
    add_column :user_infos, :car_price, :string
    add_column :user_infos, :city, :string
  end
end
