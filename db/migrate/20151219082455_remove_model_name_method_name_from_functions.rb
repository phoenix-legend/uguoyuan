class RemoveModelNameMethodNameFromFunctions < ActiveRecord::Migration
  def change
    remove_column :functions, :model_name
    remove_column :functions, :method_name
  end
end
