class AddChannelName < ActiveRecord::Migration
  def change
    add_column :car_user_infos, :channel, :string
  end
end
