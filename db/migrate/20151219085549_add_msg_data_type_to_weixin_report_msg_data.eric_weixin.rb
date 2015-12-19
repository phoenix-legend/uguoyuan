# This migration comes from eric_weixin (originally 20150610040059)
class AddMsgDataTypeToWeixinReportMsgData < ActiveRecord::Migration
  def change
    add_column :weixin_report_msg_data, :msg_data_type, :string
  end
end
