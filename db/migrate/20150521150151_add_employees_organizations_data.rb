class AddEmployeesOrganizationsData < ActiveRecord::Migration
  def up
    execute "INSERT INTO employees_organizations(`id`,`organization_id`,`employee_id`)VALUES(1,1,1);"
  end
end
