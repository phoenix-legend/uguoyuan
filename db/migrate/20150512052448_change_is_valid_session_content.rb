class ChangeIsValidSessionContent < ActiveRecord::Migration
  def change
    change_column :session_contents, :is_valid, :boolean, default: true
  end
end
