namespace :zongjie do
  desc "检测超时签收的订单, 做签收"
  # rake zongjie:timeout_auto_sign_in RAILS_ENV=production
  #  /data/projects/command/uguoyuan/order_signin_timeout.sh
  # 9点, 12点, 3点,晚8点执行4次
  task :timeout_auto_sign_in => :environment do
    jincheng = `ps -ef | grep timeout_auto_sign_in`
    match_data = jincheng.split /\n/
    if match_data.length > 4
      pp 'uguoyuan 前一次未执行完毕，退出任务'
    else
      ##  开始干活
      if [8,12,16,20].include? Time.now.hour
        EricWeixin::Xiaodian::Order.timeout_auto_sign_in  #检测超时签收的订单, 做签收
      end

      pp '检测超时签收的订单, 做签收  已执行完成'
    end
  end


end