# This migration comes from eric_weixin (originally 20150906064203)
class AddErrorCountToWeixinMediaNews < ActiveRecord::Migration
  def change
    add_column :weixin_media_news, :error_count, :integer
  end
end
