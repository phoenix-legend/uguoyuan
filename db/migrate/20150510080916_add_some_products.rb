class AddSomeProducts < ActiveRecord::Migration
  def up
    # execute "truncate products;"
    # execute "INSERT INTO products(id,name) VALUES (1,'1元洗车'), (2,'保养免单券'), (3,'违章查询'), (4, '车险比价')"
  end

  def down
    # execute "truncate products;"
  end
end
