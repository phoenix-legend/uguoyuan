class AddBrandToCarUserInfo < ActiveRecord::Migration
  def change
    add_column :car_user_infos, :brand, :string
  end
end
