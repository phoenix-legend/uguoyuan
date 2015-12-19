class AddClomnToUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :gender, :string, :limit => 20
    add_column :user_infos, :birthday, :date
  end
end
