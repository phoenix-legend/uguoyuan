class SelledProductRedpack < ActiveRecord::Base
  belongs_to :selled_product

  # 创建红包待发列表
  def self.create_selled_product_red_pack selled_product, type
    spr = SelledProductRedpack.new selled_product_id: selled_product.id,
                                   redpack_type: type,
                                   order_owner_openid: selled_product.order_owner_openid,
                                   send_status: 0
    selled_product.all_redpack_number +=1
    selled_product.save!
    spr.plan_amount = spr.get_rand_number_amount
    spr.save!
    spr
  end


  def self.send_bak_redpack options, order_owner_openid
    tuijianren = EricWeixin::WeixinUser.where(openid: order_owner_openid).first
    spr = SelledProductRedpack.where(redpack_type: 'main', order_owner_openid: order_owner_openid, send_status: 0 ).order(id: :asc).first
    if !spr.blank?
      spr.send_redpack options[:FromUserName]
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: "朋友推荐关注后有红包：").v||"客官，多亏#{tuijianren.nickname}的引见，见面礼已双手奉上，请笑纳。现在购买还会有首单红包即刻奉上，事不宜迟，赶紧下手。
U果源的水果都是纯天然，无后期加工，价格公道，有需求可随时找我，U果源一直都在你身边。"}
    else
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: "朋友推荐关注后无红包：").v||"客官你好，#{tuijianren.nickname}的引见红包名额已用完。
不过没关系，现在购买就会有首单红包即刻奉上。U果源的水果都是纯天然，无后期加工，价格也公道，尝一个吧。有需求可随时找我，U果源一直都在你身边。"}
    end
  end



  # 发送指定用户的首单红包，发送后再补一条信息。
  # 参数为TX回传回来的参数，直接传过来。
  # 这里会用到两个参数： FromUserName    ToUserName
  def self.send_main_redpack options
    # 发送首次红包
    spr = SelledProductRedpack.where(redpack_type: 'main', order_owner_openid: options[:FromUserName], send_status: 0 ).first
    if !spr.blank?
      spr.send_redpack options[:FromUserName]
      sleep(1)
      #发送信息
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: "开箱红包收到后提示：").v||'恭喜你，您已抽到开箱红包，非常感谢您的支持。
U果源所有水果都尽可能保持在农村果园的原始状态，这样更有利于保鲜。有问题请在微信中直接留言，客服小妹将尽快与您沟通。'}
    else
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: "开箱红包扫描多次没有红包提示：").v||'抽奖资格已用完，请慢慢享用你的水果...
U果源一直在你身边，有需求随时找我哟。'}
    end
  end



  # 发送指定用户的首单红包，发送后再补一条信息。
  # 参数为TX回传回来的参数，直接传过来。
  # 这里会用到两个参数： FromUserName    ToUserName
  def self.send_first_order_redpack options
    # 发送首单红包
    spr = SelledProductRedpack.where(redpack_type: 'first', order_owner_openid: options[:FromUserName], send_status: 0 ).first
     if !spr.blank?
       spr.send_redpack order.openid
       sleep(1)
       #发送信息
       EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                              openid: options[:FromUserName],
                                                              message_type: 'text',
                                                              data: {:content => SystemConfig.find_or_create_by!(k: "收到首单红包后文案").v||'首单红包礼物已奉上，非常感谢您的支持。
U果源的一路成长离不开您的关注，任何问题请在微信公众账号直接留言，客服小妹将尽快与您沟通。'}
     else
       EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                              openid: options[:FromUserName],
                                                              message_type: 'text',
                                                              data: {:content => SystemConfig.find_or_create_by!(k: "订单付款后文案-非首单").v||'非常感谢您的支持，U果源的一路成长离不开您的关注，任何问题请在微信公众账号直接留言，客服小妹将尽快与您沟通。'}
     end
  end

  # 把 selled_product_redpack 发给指定用户
  def send_redpack openid
    red_pack_options = {}
    red_pack_options[:wishing] = self.get_redpack_wishing 'redpack_wishing'
    red_pack_options[:client_ip] = '101.231.116.38'
    red_pack_options[:act_name] = self.get_redpack_wishing 'redpack_act_name'
    red_pack_options[:remark] = self.get_redpack_wishing 'redpack_remark'
    red_pack_options[:send_name] = self.get_redpack_wishing 'redpack_send_name'
    red_pack_options[:re_openid] = openid
    red_pack_options[:total_amount] = self.plan_amount

    redpack_order = EricWeixin::RedpackOrder.create_redpack_order red_pack_options  # 发红包

    if redpack_order.class.name == "EricWeixin::RedpackOrder"
      pp "给 #{openid} 发红包完成，金额 #{self.plan_amount}："
      self.really_amount = self.plan_amount
      self.weixin_redpack_id= redpack_order.id
      self.send_status = 1
      self.save!
      sp = self.selled_product
      sp.send_redpack_number += 1
      sp.save!
      sp
    else
      self.receive_openid = openid
      self.save!
      pp "给 #{openid} 发红包失败，失败原因是："
      pp redpack_order
    end
  end

  # 得到随机金额，介于 100--110
  def get_rand_number_amount
    (rand 10) + 100
  end

  def get_redpack_wishing type
    case type
      when 'redpack_wishing'
        SystemConfig.find_or_create_by!(k: "redpack_wishing_#{self.redpack_type}").v||'祝：平安 健康 幸福'
      when 'redpack_act_name'
        SystemConfig.find_or_create_by!(k: "redpack_act_name_#{self.redpack_type}").v||'首单送礼'
      when 'redpack_remark'
        SystemConfig.find_or_create_by!(k: "redpack_remark_#{self.redpack_type}").v||'别忘了分享好友哟'
      when 'redpack_send_name'
        SystemConfig.find_or_create_by!(k: "redpack_send_name_#{self.redpack_type}").v||'U果源'
    end
  end
end