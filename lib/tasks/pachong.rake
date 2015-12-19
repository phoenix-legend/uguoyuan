namespace :pachongchong do
	desc "每天更新班级状态  rake pachongchong:che168 RAILS_ENV=production"
	task :che168 => :environment do
    jincheng = `ps -ef | grep pachong`
		match_data = jincheng.split /\n/
    if match_data.length > 4
			pp '前一次未执行完毕，退出任务'

    else
			pp '前一次已完成， GO RUN'
			UserSystem::CarUserInfo.run_men
    end
	end
end