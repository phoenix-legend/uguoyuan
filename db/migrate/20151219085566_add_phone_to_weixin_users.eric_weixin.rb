# This migration comes from eric_weixin (originally 20150908023239)
class AddPhoneToWeixinUsers < ActiveRecord::Migration
  def change
    add_column :weixin_users, :phone, :string
  end
end
