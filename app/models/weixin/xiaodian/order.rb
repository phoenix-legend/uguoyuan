class Weixin::Xiaodian::Order < EricWeixin::Xiaodian::Order

  CLOSING_STATUS = {
      0 => '未处理',
      1 => '已结算',
      2 => '不结算',
      3 => '发红包异常'
  }

  def product_price
    order_total_price/product_count
  end

  # 本订单提成
  def calc_sale_payment
    return sale_payment if closing_status != 0
    self.sale_payment = if product.basic_price.blank?
      0
    elsif product_count.blank?
      0
    else
      result = order_total_price - product.basic_price * product_count rescue 'error:计算出错'
      result = 0 if result.to_f < 0
      result.to_f
    end

    self.save!
    self.sale_payment
  end

  # 订单生成后发提成红包
  # 满足以下条件才发红包
  # 此订单是＊红富士＊
  # 提成大于0
  def self.fa_ti_cheng order_id, to_openid
    order = find_by_order_id(order_id)
    return 0 if order.blank?

    if order.product_name.blank?
      order.get_info
    end
    BusinessException.raise '产品名为空' if order.product_name.blank?
    unless order.product_name.include? SystemConfig.v( 'ticheng_product_name_key', '红富士' )
      order.closing_status = 2
      order.save!
      return 0
    end

    user = Weixin::WeixinUser.find_by_openid to_openid
    if user.first_register_channel.blank?
      order.closing_status = 2
      order.save!
      return 0
    end

    origin_user = Weixin::WeixinUser.find_by_self_channel user.first_register_channel
    if origin_user.blank?
      order.closing_status = 2
      order.save!
      return 0
    end

    BusinessException.raise '购买数量为空' if order.product_count.blank?
    BusinessException.raise '合计金额为空' if order.order_total_price.blank?
    BusinessException.raise 'openid为空' if order.openid.blank?
    BusinessException.raise '产品数量小于等于0' if order.product_count <= 0
    BusinessException.raise '成本价标的太低，成本/售价<70%' if (order.product.basic_price*1.0)/(order.order_total_price/order.product_count) < 0.7

    # 只有订单状态为未结算时，才更新佣金，其他情况不更新
    order.calc_sale_payment if order.closing_status == 0

    # 提成<0 不发红包
    return 0 if order.sale_payment < 0


    red_pack_options = {}
    red_pack_options[:wishing] = '继续加油哦'
    red_pack_options[:client_ip] = '101.231.116.38'
    red_pack_options[:act_name] = '苹果分销'
    red_pack_options[:remark] = '加油'
    red_pack_options[:send_name] = 'U果源'
    red_pack_options[:re_openid] = origin_user.openid
    red_pack_options[:total_amount] = order.sale_payment   #金额随机

    redpack_order = EricWeixin::RedpackOrder.create_redpack_order red_pack_options # 发红包

    if redpack_order.class.name == "EricWeixin::RedpackOrder" #发送成功
      pp '成功'
      order.closing_status = 1
      order.save!
    else #发送失败，先记录名称，后续补发
      order.closing_status = 3
      order.save!
      pp "给 #{openid} 发红包失败，失败原因是："
      pp redpack_order
      redpack_order.to_logger
    end
  end
end