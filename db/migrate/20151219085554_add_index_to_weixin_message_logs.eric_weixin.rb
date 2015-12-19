# This migration comes from eric_weixin (originally 20150612104303)
class AddIndexToWeixinMessageLogs < ActiveRecord::Migration
  def change
  	add_index :weixin_message_logs, :message_id
  	add_index :weixin_message_logs, :create_time
  	add_index :weixin_message_logs, :created_at
  end
end