class AddFunctionRoleData < ActiveRecord::Migration
  def up
    execute "INSERT INTO functions_roles(`function_id`,`role_id`)VALUES(1,1),(8,1),(9,1),(10,1),(11,1),(38,1),(39,1),(40,1),(41,1),(65,1);"
  end
end
