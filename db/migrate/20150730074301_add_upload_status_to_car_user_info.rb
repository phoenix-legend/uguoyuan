class AddUploadStatusToCarUserInfo < ActiveRecord::Migration
  def change
    # weidaoru, yicunzai, chenggong, shibai
    add_column :car_user_infos, :upload_status, :string, :default => 'weidaoru'

    add_column :car_user_infos, :shibaiyuanyin, :string, :limit => '100'

    add_column :car_user_infos, :bookid, :string
  end
end
