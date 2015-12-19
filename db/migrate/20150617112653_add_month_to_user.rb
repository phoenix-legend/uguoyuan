class AddMonthToUser < ActiveRecord::Migration
  def change
    add_column :user_infos, :month, :integer
  end
end
