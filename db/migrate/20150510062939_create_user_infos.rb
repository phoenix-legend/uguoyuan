class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.string :name
      t.string :phone
      t.string :channel
      t.string :car_number

      t.timestamps
    end
  end
end
