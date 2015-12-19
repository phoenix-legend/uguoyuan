class AddColumnToUserInfoCar < ActiveRecord::Migration
  def change
    add_column :car_user_infos, :tt_upload_status, :string, :default => 'weishangchuan' # 0代表不上传
    add_column :car_user_infos, :tt_email_status, :string, :default => 'weifasong' # 0代表
    add_column :car_user_infos, :tt_code, :string
    add_column :car_user_infos, :tt_error, :string
    add_column :car_user_infos, :tt_message, :string
    add_column :car_user_infos, :tt_result, :string
  end
end
