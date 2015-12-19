# This migration comes from eric_weixin (originally 20150914061051)
class CreateJsapiTickets < ActiveRecord::Migration
  def change
    create_table :weixin_jsapi_tickets do |t|
      t.string :jsapi_ticket
      t.string :expired_at
      t.integer :public_account_id
      t.timestamps
    end
  end
end
