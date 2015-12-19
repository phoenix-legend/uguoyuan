class AddEmployeeAdminData < ActiveRecord::Migration
  def up
    execute "INSERT INTO employees(`id`,`email`,`real_name`,`password`,`status`)VALUES(1,'admin@baohe001.com','admin','e10adc3949ba59abbe56e057f20f883e',1)"
  end
end
