class CreateCarUserInfo < ActiveRecord::Migration
  def change
    create_table :car_user_infos do |t|
      t.string :name
      t.string :phone
      t.string :che_xing
      t.string :che_ling
      t.string :city
      t.string :city_chinese
      t.text :note
      t.string :detail_url, :limit =>  1000
      t.string :site_name
      t.boolean :need_update, :default => true
      t.integer :milage
      t.timestamps
    end
  end
end
