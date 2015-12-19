class AddSortByAndOnlineToTemplatesProducts < ActiveRecord::Migration
  def change
    add_column :templates_products, :sort_by, :integer
    add_column :templates_products, :online, :boolean
  end
end
