# This migration comes from eric_weixin (originally 20150813080541)
class AddMchIdToWeixinPublicAccounts < ActiveRecord::Migration
  def change
    add_column :weixin_public_accounts, :mch_id, :string
  end
end
