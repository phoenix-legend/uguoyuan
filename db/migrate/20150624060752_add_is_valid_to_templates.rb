class AddIsValidToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :is_valid, :boolean
  end
end
