namespace :zongjie do
	desc "检测超时签收的订单, 做签收"
  # rake zongjie:timeout_auto_sign_in RAILS_ENV=production
  # 9点, 12点, 3点,晚8点执行4次
	task :timeout_auto_sign_in => :environment do
		Weixin::Xiaodian::Order.timeout_auto_sign_in
    pp '检测超时签收的订单, 做签收  已执行完成'
	end





end