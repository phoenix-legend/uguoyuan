class AddFabushijianToCarUserInfos < ActiveRecord::Migration
  def change
    add_column :car_user_infos, :fabushijian, :string, limit: 30
  end
end
