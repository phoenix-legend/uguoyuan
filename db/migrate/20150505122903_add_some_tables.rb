class AddSomeTables < ActiveRecord::Migration
  def change
    execute "CREATE TABLE `employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `real_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `work_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `first_work_date` date DEFAULT NULL,
  `entry_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_employees_on_email` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"


    execute "CREATE TABLE `organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"


    execute "CREATE TABLE `employees_roles` (
  `employee_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"


    execute "CREATE TABLE `employees_organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;"

    execute "CREATE TABLE `organizations_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"

    execute "CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"

    execute "CREATE TABLE `functions_roles` (
  `function_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"

    execute "CREATE TABLE `functions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `method_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `page_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"

  execute "INSERT INTO `functions` (`id`, `model_name`, `method_name`, `title`, `description`, `created_at`, `updated_at`, `parent_id`, `page_url`)
VALUES
	(1, NULL, NULL, '管理平台', NULL, '2014-09-27 09:32:38', '2014-09-27 09:32:38', -1, NULL),
	(8, NULL, NULL, '权限管理', '', '2014-10-08 07:02:43', '2014-10-08 07:02:43', 1, ''),
	(9, NULL, NULL, '功能管理', '', '2014-10-08 07:03:59', '2014-10-08 07:03:59', 8, '/cms/employee_validate/functions/list'),
	(10, NULL, NULL, '角色管理', '', '2014-10-08 07:04:44', '2014-10-08 07:04:44', 8, '/cms/roles'),
	(11, NULL, NULL, '用户设置', '', '2014-10-08 07:09:54', '2014-10-08 07:09:54', 8, '/cms/employees');
"
    execute "INSERT INTO `functions` (`id`, `model_name`, `method_name`, `title`, `description`, `created_at`, `updated_at`, `parent_id`, `page_url`)
VALUES
	(38, NULL, NULL, '人事管理', '', '2015-01-06 15:07:40', '2015-01-06 15:07:40', 1, ''),
	(39, NULL, NULL, '员工一览', '', '2015-01-06 15:07:40', '2015-01-06 15:07:40', 38, '/cms/employees'),
	(40, NULL, NULL, '员工入职', '', '2015-01-06 15:07:40', '2015-01-06 15:07:40', 38, '/cms/employees/new'),
	(41, NULL, NULL, '组织架构', '', '2015-01-06 15:07:40', '2015-01-06 15:07:40', 8, '/cms/personal/organizations');
"

    execute "INSERT INTO `functions` (`id`, `model_name`, `method_name`, `title`, `description`, `created_at`, `updated_at`, `parent_id`, `page_url`)
VALUES
	(65, NULL, NULL, '自定义配置管理', '', '2015-01-06 15:07:40', '2015-01-06 15:07:40', 8, '/cms/sys/custom_configs');"
  end


end
