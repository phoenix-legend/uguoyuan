class CreateCarInsurancePrices < ActiveRecord::Migration
  def change
    create_table :car_insurance_prices do |t|
      t.string :city_name
      t.integer :car_price
      t.string :comp_name
      t.integer :insurance_price

      t.timestamps
    end
  end
end
