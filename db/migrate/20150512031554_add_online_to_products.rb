class AddOnlineToProducts < ActiveRecord::Migration
  def change
    add_column :products, :online, :boolean
  end
end
