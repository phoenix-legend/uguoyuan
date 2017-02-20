# This migration comes from eric_weixin (originally 20150817105643)
class AlertWeixinReplyMessageRulesSReplyMessageLength < ActiveRecord::Migration
  def change
    change_column :weixin_reply_message_rules, :reply_message, :text
  end
end
