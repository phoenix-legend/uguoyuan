class CreateSystemConfig < ActiveRecord::Migration
  def change
    create_table :system_configs do |t|
      t.string :k
      t.text :v
      t.timestamps
    end
  end
end
