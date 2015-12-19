class CreateSessionContents < ActiveRecord::Migration
  def change
    create_table :session_contents do |t|
      t.string :value
      t.boolean :is_valid

      t.timestamps
    end
  end
end
