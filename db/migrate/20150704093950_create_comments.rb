class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :product_id
      t.string :nick_name, limit: 20
      t.string :city
      t.string :phone
      t.integer :sex, default: 1
      t.string :content, limit: 1000
      t.datetime :comment_time

      t.timestamps
    end
  end
end
