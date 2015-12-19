class AddPriceToCarUserInfo < ActiveRecord::Migration
  def change
    add_column :car_user_infos, :price, :string, :limit => 20
  end
end
