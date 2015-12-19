class ChangeValueOfSessionContent < ActiveRecord::Migration
  def change
    change_column :session_contents, :value, :string, limit: 1000
  end
end
