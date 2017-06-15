# 2016-04-04 整个类都是小朋为了发提成而创建的， 临时先不用。
# 2017-05-21 代理返佣研发功能

class Weixin::Xiaodian::Order < EricWeixin::Xiaodian::Order

  def owner
    users = Weixin::WeixinUser.find_by_openid self.openid
    users
  end

  def product_price
    order_total_price/product_count
  end

  # 发芒果时通知的用户列表
  def self.get_mongo_order_tongzhi_user
    {
        "oliNLwMqJj8nnhN848FjTctMwgWo" => '壹品农夫（雷俊淞）',
        "oliNLwMWFvoe2dslrfIwMx0ktNWA" => "壹品农夫(琪琪)",
        "oliNLwPCNJDNpqPFpVs7m-PHP0nI" => "旅途记得回家",
        "oliNLwN5ggbRmL4g723QVOZ6CfAg" => "琦",
        "oliNLwBnn30D5hP3Elug7MffBQjQ" => "家和万事兴"
    }.keys
  end

  #发其它水果通知的用户列表
  def self.other_order_tongzhi_user
    {
        "oliNLwN5ggbRmL4g723QVOZ6CfAg" => "琦"
    }.keys
  end

  # 发订单通知
  # todo 按不同的品类, 发通知给不同的用户
  def self.order_tongzhi order_id, options

    order = ::EricWeixin::Xiaodian::Order.where("order_id = ?", order_id).first
    1.upto(10) do
      if order.receiver_name.blank?
        sleep 1
        order = order.reload
      end
    end

    notification_user_openids = if order.product_name.match /芒果/
                                  Weixin::Xiaodian::Order.get_mongo_order_tongzhi_user
                                else
                                  Weixin::Xiaodian::Order.other_order_tongzhi_user
                                end
    # ['oliNLwN5ggbRmL4g723QVOZ6CfAg','oliNLwDRVFCo-01w21xkmfydRZio'].each do |openid| #我和我妈
    notification_user_openids.each do |openid| # 我自己
      EricWeixin::TemplateMessageLog.send_template_message openid: openid,
                                                           template_id: "g5zjxJOrBqKGfvgQvb22Palm_j9qRz3bNlYtVnbQkng",
                                                           topcolor: '#00FF00',
                                                           public_account_id: 1,
                                                           data: {
                                                               first: {value: "#{order.product_name}有新的订单，#{order.product_count}个"},
                                                               keyword1: {value: order.id},
                                                               keyword2: {value: "#{order.receiver_name}/#{order.receiver_phone}"},
                                                               keyword3: {value: "#{order.order_total_price.to_f/100}元"},
                                                               keyword4: {value: "#{order.receiver_province} #{order.receiver_city} #{order.receiver_zone} #{order.receiver_address}"},
                                                               keyword5: {value: order.created_at.chinese_format},
                                                               remark: {value: '有新的订单，请及时处理'}
                                                           }
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: openid,
                                                             message_type: 'text',
                                                             data: {:content => "#{order.receiver_province} #{order.receiver_city} #{order.receiver_zone} #{order.receiver_address}   #{order.receiver_name}  #{order.receiver_phone}  #{order.product_name}   数量：#{order.product_count}"},
                                                             message_id: options[:MsgId]
    end

    CommissionCharge.create_commission_charge order.id

  end

  def self.timeout_auto_sign_in
    orders = Weixin::Xiaodian::Order.where("sign_in_timeout_time < ? and sign_in_flg = ?", Time.now, false)
    orders.each do |order|
      ::EricWeixin::Process.order_sign_in order.id
    end

  end

  # CLOSING_STATUS = {
  #     0 => '未处理',
  #     1 => '已结算',
  #     2 => '不结算',
  #     3 => '发红包异常'
  # }


  # 本订单提成
  # def calc_sale_payment
  #   return sale_payment if closing_status != 0
  #   self.sale_payment = if product.basic_price.blank?
  #     0
  #   elsif product_count.blank?
  #     0
  #   else
  #     result = order_total_price - product.basic_price * product_count rescue 'error:计算出错'
  #     result = 0 if result.to_f < 0
  #     result.to_f
  #   end
  #
  #   self.save!
  #   self.sale_payment
  # end

  # 订单生成后发提成红包
  # 满足以下条件才发红包
  # 此订单是＊红富士＊
  # 提成大于0
  # 待检查
  # def self.fa_ti_cheng order_id, to_openid
  #   order = find_by_order_id(order_id)
  #   return 0 if order.blank?
  #
  #   if order.product_name.blank?
  #     order.get_info
  #   end
  #   BusinessException.raise '产品名为空' if order.product_name.blank?
  #   unless order.product_name.include? SystemConfig.v( 'ticheng_product_name_key', '红富士' )
  #     order.closing_status = 2
  #     order.save!
  #     return 0
  #   end
  #
  #   user = Weixin::WeixinUser.find_by_openid to_openid
  #   if user.first_register_channel.blank?
  #     order.closing_status = 2
  #     order.save!
  #     return 0
  #   end
  #
  #   origin_user = Weixin::WeixinUser.find_by_self_channel user.first_register_channel
  #   if origin_user.blank?
  #     order.closing_status = 2
  #     order.save!
  #     return 0
  #   end
  #
  #   BusinessException.raise '购买数量为空' if order.product_count.blank?
  #   BusinessException.raise '合计金额为空' if order.order_total_price.blank?
  #   BusinessException.raise 'openid为空' if order.openid.blank?
  #   BusinessException.raise '产品数量小于等于0' if order.product_count <= 0
  #   BusinessException.raise '成本价标的太低，成本/售价<70%' if (order.product.basic_price*1.0)/(order.order_total_price/order.product_count) < 0.7
  #
  #   # 只有订单状态为未结算时，才更新佣金，其他情况不更新
  #   order.calc_sale_payment if order.closing_status == 0
  #
  #   # 提成<0 不发红包
  #   return 0 if order.sale_payment < 0
  #
  #
  #   red_pack_options = {}
  #   red_pack_options[:wishing] = '继续加油哦'
  #   red_pack_options[:client_ip] = '101.231.116.38'
  #   red_pack_options[:act_name] = '苹果分销'
  #   red_pack_options[:remark] = '加油'
  #   red_pack_options[:send_name] = 'U果源'
  #   red_pack_options[:re_openid] = origin_user.openid
  #   red_pack_options[:total_amount] = order.sale_payment   #金额随机
  #
  #   redpack_order = EricWeixin::RedpackOrder.create_redpack_order red_pack_options # 发红包
  #
  #   if redpack_order.class.name == "EricWeixin::RedpackOrder" #发送成功
  #     pp '成功'
  #     order.closing_status = 1
  #     order.save!
  #   else #发送失败，先记录名称，后续补发
  #     order.closing_status = 3
  #     order.save!
  #     pp "给 #{openid} 发红包失败，失败原因是："
  #     pp redpack_order
  #     redpack_order.to_logger
  #   end
  # end
end