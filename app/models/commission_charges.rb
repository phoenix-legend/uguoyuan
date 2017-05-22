class CommissionCharge < ActiveRecord::Base
  PAY_STATUS_NEED_PAY = 'needpay'
  PAY_STATUS_PAYED = 'pay_success'
  PAY_STATUS_FIELD = 'pay_failure'

  def self.create_commission_charge order_id
    order = Weixin::Xiaodian::Order.find order_id
    owner = order.owner
    return if owner.agency_openid.blank?
    agency = owner.agency
    cc = CommissionCharge.new weixin_xiaodian_order_id: order.id,
                              agency_openid: agency.openid,
                              agency_nickname: agency.nickname,
                              customer_openid: owner.openid,
                              customer_nickname: owner.nickname,
                              commision_charge_number: order.order_total_price/10,
                              plan_payment_time: order.sign_in_timeout_time.to_date,
                              pay_status: PAY_STATUS_NEED_PAY
    cc.save!
    EricWeixin::MultCustomer.send_customer_service_message weixin_number: "gh_5734a2ca28e5", #公众号weixin number, 参考public accounts表
                                                           openid: agency.openid,
                                                           message_type: 'text',
                                                           data: {:content => "您有一个在途红包,金额#{cc.commision_charge_number.to_f / 100}元, 预计 #{cc.plan_payment_time.chinese_format_day}到账,或#{owner.nickname}签收时到账。"},
                                                           message_id: options[:MsgId]
  end
end