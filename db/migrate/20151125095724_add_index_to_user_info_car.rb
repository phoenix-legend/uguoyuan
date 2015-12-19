class AddIndexToUserInfoCar < ActiveRecord::Migration
  def change
    add_index :car_user_infos, :tt_upload_status
    add_index :car_user_infos, :tt_email_status
  end
end
