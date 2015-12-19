# This migration comes from eric_weixin (originally 20150610072952)
class AddTotalOnlineTimeAndUserSourceToWeixinReportNewsData < ActiveRecord::Migration
  def change
    add_column :weixin_report_news_data, :total_online_time, :integer
    add_column :weixin_report_news_data, :user_source, :integer
  end
end
