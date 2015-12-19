class AddEngineNoToUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :engine_no, :string
    add_column :user_infos, :vin_no, :string
  end
end
