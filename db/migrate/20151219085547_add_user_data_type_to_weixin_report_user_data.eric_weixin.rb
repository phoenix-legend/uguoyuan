# This migration comes from eric_weixin (originally 20150610035901)
class AddUserDataTypeToWeixinReportUserData < ActiveRecord::Migration
  def change
    add_column :weixin_report_user_data, :user_data_type, :string
  end
end
