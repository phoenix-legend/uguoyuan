class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :show_name
      t.string :real_name

      t.timestamps
    end
  end
end
