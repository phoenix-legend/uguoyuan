class AddProductsData < ActiveRecord::Migration
  def up
    execute "INSERT INTO `products` (`name`, `created_at`, `updated_at`, `description`, `cover_image`, `url`, `online`, `sort_by`, `app_name`, `server_name`)
    VALUES
    ('保养＋足不出户', NULL, '2015-05-21 13:53:30', '[\"说明1\", \"说明2\", \"说明3\"]', 'image201505212153301.jpg', '/wz/order_system/products/new_appointment?id=1', 1, 99, '', NULL),
    ('1元洗车', NULL, '2015-05-21 15:30:08', '', 'image201505212154521.jpg', '/wz/order_system/products/new_appointment?id=2', 1, 98, '', NULL),
    ('违章查询', NULL, '2015-05-21 14:02:32', NULL, 'image201505131807481.png', '', 0, 4, '', NULL),
    ('车险比价', NULL, '2015-05-21 14:03:24', NULL, 'image201505212203241.jpg', '/wz/order_system/products/compare_price', 1, 97, '', NULL);"
  end
end
