# This migration comes from eric_weixin (originally 20150906072855)
class CreateWeixinMediaNewsSentRecords < ActiveRecord::Migration
  def change
    create_table :weixin_media_news_sent_records do |t|
      t.integer :media_news_id
      t.string :msg_id
      t.integer :sent_count
      t.integer :total_count
      t.integer :filter_count
      t.integer :error_count
      t.string :status

      t.timestamps
    end
  end
end
