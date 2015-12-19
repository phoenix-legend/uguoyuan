class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :product_id
      t.integer :user_info_id
      t.integer :status

      t.timestamps

    end
  end
end
