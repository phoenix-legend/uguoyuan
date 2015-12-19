class AddIpToUserInfos < ActiveRecord::Migration
  def change
    add_column :user_infos, :ip, :string
  end
end
