class CreateSelledProductRedpack < ActiveRecord::Migration
  def change
    create_table :selled_product_redpacks do |t|
      t.integer :selled_product_id
      t.integer :weixin_redpack_id
      t.string :redpack_type
      t.integer :plan_amount
      t.integer :really_amount
      t.string :receive_openid
      t.string :order_owner_openid
      t.integer :send_status
      t.timestamps
    end
  end
end
