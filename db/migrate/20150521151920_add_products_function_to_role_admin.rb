class AddProductsFunctionToRoleAdmin < ActiveRecord::Migration
  def up
    execute "INSERT INTO functions_roles VALUES(66,1),(67,1),(68,1);"
  end
end
