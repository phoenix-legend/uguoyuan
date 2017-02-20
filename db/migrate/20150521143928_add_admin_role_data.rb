class AddAdminRoleData < ActiveRecord::Migration
  def up
    execute "INSERT INTO roles(`id`,`name`) VALUES(1,'管理员');"
  end
end
