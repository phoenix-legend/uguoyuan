class CreateCarBrand < ActiveRecord::Migration
  def change
    create_table :car_brands do |t|
      t.string :name
      t.string :key_str
    end
  end
end
