class AddProductsFunctionsData < ActiveRecord::Migration
  def up
    execute "INSERT INTO `functions` (`id`, `model_name`, `method_name`, `title`, `description`, `created_at`, `updated_at`, `parent_id`, `page_url`)
            VALUES
            (66, NULL, NULL, '产品管理', NULL, '2014-09-27 09:32:38', '2014-09-27 09:32:38', 1, NULL),
            (67, NULL, NULL, '产品列表', '', '2014-10-08 07:02:43', '2014-10-08 07:02:43', 66, '/cms/order_system/products/'),
            (68, NULL, NULL, '创建产品', '', '2014-10-08 07:02:43', '2014-10-08 07:02:43', 66, '/cms/order_system/products/new/')"
  end
end
