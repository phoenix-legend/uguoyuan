class AddSortByToComment < ActiveRecord::Migration
  def change
    add_column :comments, :sort_by, :integer, default: 0
  end
end
