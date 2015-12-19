class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.integer :parent_id
      t.integer :level
      t.string :name
      t.decimal :lat, default: 0.00000
      t.decimal :lon, default: 0.00000
      t.string :citycode
      t.string :regioncode

      t.timestamps
    end
  end
end
