class CreateTemplatesProducts < ActiveRecord::Migration
  def change
    create_table :templates_products do |t|
      t.integer :template_id
      t.integer :product_id
      t.string :cover_image

      t.timestamps
    end
  end
end
