# This migration comes from eric_weixin (originally 20151124113559)
class AddOpenidToWeixinXiaodianOrder < ActiveRecord::Migration
  def change
    add_column :weixin_xiaodian_orders, :openid, :string
    add_column :weixin_xiaodian_orders, :created_at, :datetime
    add_column :weixin_xiaodian_orders, :updated_at, :datetime
  end
end
