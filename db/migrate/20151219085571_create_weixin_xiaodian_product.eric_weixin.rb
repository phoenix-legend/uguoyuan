# This migration comes from eric_weixin (originally 20151116085047)
class CreateWeixinXiaodianProduct < ActiveRecord::Migration
  def change
    create_table :weixin_xiaodian_products do |t|
      t.string :product_id, :limit => 100
      t.string :name, :limit => 200
      t.text :properties
      t.string :sku_info, :limit => 300
    end
  end
end
