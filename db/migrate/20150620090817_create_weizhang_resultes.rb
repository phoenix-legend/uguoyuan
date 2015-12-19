class CreateWeizhangResultes < ActiveRecord::Migration
  def change
    create_table :weizhang_results do |t|
      t.string :province, :limit => 20
      t.string :car_number, :limit => 20
      t.string :city, :limit => 20
      t.string :district, :limit => 20
      t.string :when, :limit => 100
      t.string :where, :limit => 1000
      t.string :why, :limit => 1000
      t.string :code, :limit => 20
      t.integer :fines
      t.integer :points
      t.integer :user_info_id
      t.integer :status
      t.timestamps
    end
  end
end
