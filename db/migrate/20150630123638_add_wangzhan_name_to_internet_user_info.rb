class AddWangzhanNameToInternetUserInfo < ActiveRecord::Migration
  def change
    add_column :internet_user_infos, :wangzhan_name, :string
  end
end
