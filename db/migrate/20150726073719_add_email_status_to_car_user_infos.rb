class AddEmailStatusToCarUserInfos < ActiveRecord::Migration
  def change
    add_column :car_user_infos, :email_status, :integer, default: 0
  end
end
