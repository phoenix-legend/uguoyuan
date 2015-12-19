class AddPayToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :pay, :boolean, default: false
  end
end
