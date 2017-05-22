class AddAgencyFlgToWeixinUser < ActiveRecord::Migration
  def change
    add_column :weixin_users, :agency_flg, :boolean, default: false  #代理标记
    add_column :weixin_users, :agency_time, :datetime #成为代理时间
    add_column :weixin_users, :agency_openid, :string  #代理的openid
  end
end
