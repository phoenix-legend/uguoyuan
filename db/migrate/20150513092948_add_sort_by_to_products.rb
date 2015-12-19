class AddSortByToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sort_by, :integer
  end
end
