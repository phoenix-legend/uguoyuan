# This migration comes from eric_weixin (originally 20150911062057)
class CreateWeixinRedpacks < ActiveRecord::Migration
  def change
    create_table :weixin_redpacks do |t|
      t.integer :weixin_redpack_order_id
      t.string :openid
      t.integer :amount
      t.datetime :rcv_time
      t.string :status

      t.timestamps
    end
  end
end
