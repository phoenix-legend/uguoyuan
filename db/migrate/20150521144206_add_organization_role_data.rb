class AddOrganizationRoleData < ActiveRecord::Migration
  def up
    execute "INSERT INTO organizations(`id`, `name`, `parent_id`, `code`) VALUES(1,'管理员',-1,'admin');"
    execute "INSERT INTO organizations_roles(`id`,`organization_id`,`role_id`)VALUES(1,1,1)"
  end
end
