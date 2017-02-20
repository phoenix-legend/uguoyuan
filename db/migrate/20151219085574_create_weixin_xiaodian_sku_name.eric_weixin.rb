# This migration comes from eric_weixin (originally 20151117015049)
class CreateWeixinXiaodianSkuName < ActiveRecord::Migration
  def change
    create_table :weixin_xiaodian_sku_names do |t|
      t.string :name
      t.integer :weixin_xiaodian_category_id
      t.string :wx_name_id
    end
  end
end
