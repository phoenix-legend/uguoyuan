class AddSelfChannelToWeixinUsers < ActiveRecord::Migration
  def change
    add_column :weixin_users, :self_channel, :string
  end
end
