class CreateCommissionCharges < ActiveRecord::Migration
  def change
    create_table :commission_charges do |t|
      t.integer :weixin_xiaodian_order_id   #订单编号
      t.string :agency_openid   #代理人员openid
      t.string :agency_nickname   #代理人员昵称
      t.string :customer_openid   #购买人员
      t.string :customer_nickname   #购买人员
      t.integer :commision_charge_number  #佣金数量(单位:分)
      t.integer :plan_payment_time #预计支付时间
      t.datetime :payment_time #支付时间
      t.string :pay_status  #支付状态, 待支付, 支付成功, 支付失败
    end
  end
end
