class CreateWeizhangLog < ActiveRecord::Migration
  def change
    create_table :weizhang_logs do |t|
      t.string :phone, :limit => 20
      t.string :car_number, :limit => 20
      t.string :engine_no, :limit => 20
      t.string :vin_no, :limit => 20
      t.string :query_types, :limit => 20

      t.text :contents
      t.timestamps
    end
  end
end
