# This migration comes from eric_weixin (originally 20150817143407)
class AddMchKeyToWeixinPublicAccount < ActiveRecord::Migration
  def change
    add_column :weixin_public_accounts, :mch_key, :string
  end
end
