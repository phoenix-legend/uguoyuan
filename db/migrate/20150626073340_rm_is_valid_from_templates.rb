class RmIsValidFromTemplates < ActiveRecord::Migration
  def change
    remove_column :templates, :is_valid
  end
end
