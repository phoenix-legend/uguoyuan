class CreateSelledProduct < ActiveRecord::Migration
  def change
    create_table :selled_products do |t|
      t.integer :weixin_xiaodian_product_id
      t.integer :weixin_xiaodian_order_id
      t.integer :all_redpack_number
      t.integer :send_redpack_number
      t.string :order_owner_openid
      t.timestamps
    end


  end
end
