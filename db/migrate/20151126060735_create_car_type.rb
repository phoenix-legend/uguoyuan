class CreateCarType < ActiveRecord::Migration
  def change
    create_table :car_types do |t|
      t.string :name
      t.integer :car_brand_id
    end
  end
end
