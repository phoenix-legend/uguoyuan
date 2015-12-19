# This migration comes from eric_weixin (originally 20150625065249)
class DeleteClomnWeixinTokenFromPublicAccount < ActiveRecord::Migration
  def change
    remove_column :weixin_public_accounts, :weixin_token
  end
end
