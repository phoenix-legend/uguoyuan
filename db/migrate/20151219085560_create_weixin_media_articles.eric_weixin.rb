# This migration comes from eric_weixin (originally 20150818094553)
class CreateWeixinMediaArticles < ActiveRecord::Migration
  def change
    create_table :weixin_media_articles do |t|
      t.string :thumb_media_id
      t.string :author
      t.string :title
      t.string :content_source_url, limit: 2000
      t.text :content
      t.string :digest, limit: 2000
      t.boolean :show_cover_pic
      t.string :tag
      t.boolean :is_first_article
      t.integer :public_account_id
      t.timestamps
    end
  end
end
