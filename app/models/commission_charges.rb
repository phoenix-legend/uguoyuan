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

    EricWeixin::TemplateMessageLog.send_template_message openid: agency.openid,
                                                         template_id: "r73CRRSmU5uyov5fmHxJm73De031rCgu_ohZX1X5q7s",
                                                         topcolor: '#00FF00',
                                                         public_account_id: 1,
                                                         data: {
                                                             # first: {value: "您的客户#{owner.nickname}有新订单"},
                                                             first: {value: "您推荐的客户有新订单"},
                                                             keyword1: {value: order.product_name},
                                                             keyword2: {value: "#{cc.commision_charge_number.to_f / 100}元"},
                                                             keyword3: {value: order.created_at.chinese_format_day},
                                                             keyword4: {value: "准备发货"},
                                                             remark: {value: "在途红包预计 #{cc.plan_payment_time.chinese_format_day}到账,或客户签收时到账。为保护用户隐私,系统不公布购买者名称,请谅解。"}
                                                         }

    #
  end

  def self.send_commission_charge order_id

    cs = CommissionCharge.find_by_weixin_xiaodian_order_id order_id

    red_pack_options = {}
    red_pack_options[:wishing] = '恭喜, 一个订单已完成签收'
    red_pack_options[:client_ip] = '101.231.116.38'
    red_pack_options[:act_name] = '感谢'
    red_pack_options[:remark] = '恭喜, 一个订单已完成签收,加油。'
    red_pack_options[:send_name] = 'U果源'
    red_pack_options[:re_openid] = cs.agency_openid
    red_pack_options[:total_amount] = cs.commision_charge_number #金额随机

    redpack_order = EricWeixin::RedpackOrder.create_redpack_order red_pack_options # 发红包
    cs.payment_time= Time.now

    if redpack_order.class.name == "EricWeixin::RedpackOrder" #发送成功
      pp "给 #{cs.agency_nickname} 发红包成功"
      cs.pay_status = PAY_STATUS_PAYED
    else #发送失败，先记录名称，后续补发
      pp "给 #{cs.agency_nickname} 发红包失败，失败原因是："
      pp redpack_order
      redpack_order.to_logger
      cs.pay_status = PAY_STATUS_FIELD
    end
    cs.save!
  end
end