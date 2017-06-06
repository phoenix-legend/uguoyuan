# This migration comes from eric_weixin (originally 20160801040113)
class AddUnionidToWeixinUsers < ActiveRecord::Migration
  def change
    add_column :weixin_users, :unionid, :string
  end
end
