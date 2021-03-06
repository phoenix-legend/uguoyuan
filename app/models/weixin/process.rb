class ::Weixin::Process
  #用户订阅回调
  def self.subscribe options, is_new
    pp options
    options[:is_new] = is_new
    event_key = unless options[:EventKey].blank?
                  if options[:EventKey].match /qrscene_/
                    options[:EventKey][8..1000]
                  else
                    options[:EventKey]
                  end
                else
                  ''
                end

    # 芒果季, 先发视频,再处理推送消息
    # Weixin::WeixinAutoReplyFunctions.delay.send_maongguo_video options[:FromUserName]


    # 处理朋友推荐，一般会用openid做为二维码参数，所以长度一般会在25位以上，先使用位数过滤一遍，可减少数据库查询负载。
    if event_key.length > 25
      weixin_user = EricWeixin::WeixinUser.where(openid: event_key).first
      if weixin_user # 如果用户不存在，再进行查询
        SelledProductRedpack.delay.send_bak_redpack options, weixin_user.openid unless weixin_user.blank?
        return true
      end
    end

    # 处理用户扫一封信二维码进来的情况...   如果您觉得好吃，记得常来~更多开箱红包等你来抢！ U果源一直在您身边，有需求随时微我哟。
    case event_key
      when /yifengxin_hongbao/
        EricWeixin::MultCustomer.delay.send_customer_service_message weixin_number: options[:ToUserName],
                                                                     openid: options[:FromUserName],
                                                                     message_type: 'text',
                                                                     data: {:content => '购买完成以后，使用订购者微信扫此二维码领取开箱红包。'}
#       when /yilabao/
#         return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
#                                                                       FromUserName: options[:ToUserName],
#                                                                       Content: '你好，欢迎品尝来自U果源的好吃的苹果🍏。
#
# 您手上的苹果是U果源直接从果农手中寄出，新鲜健康、无污染，不打腊。
#
# 如果觉得味道不错，可直接从下方菜单中购买，感谢您的支持！'
#       when /yikao_nianhui_2016/
#         return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
#                                                                       FromUserName: options[:ToUserName],
#                                                                       Content: '户外年会红包领取已结束'

      when /sale-agent-/
        openid = event_key.gsub('sale-agent-', '')
        user = EricWeixin::WeixinUser.where(openid: options[:FromUserName]).first
        return unless user.agency_openid.blank?
        return if user.id <= 1466 #已经注册过的, 就不再成为别人的代理会员。
        agency = EricWeixin::WeixinUser.where(openid: openid).first
        user.agency_openid = agency.openid
        user.save!
    end

    true
  end


  #用户取消订阅回调
  def self.unsubscribe options
    "unsubscribe.......".to_logger
    true
  end

  #用户点击回调
  def self.click_event event_key, options
    case event_key
      when 'shouhoudescript'
        return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                      FromUserName: options[:ToUserName],
                                                                      Content: SystemConfig.v('售后信息', '芒果请联系 13472446647,上海')
      when 'tuihuanshuoming'

        EricWeixin::MultCustomer.delay.send_customer_service_message weixin_number: "gh_5734a2ca28e5", #公众号weixin number, 参考public accounts表
                                                               openid: options[:FromUserName],
                                                               message_type: 'image',
                                                               data: {:media_id => 'QH-v2WNZTxGMY9gYtYRtf2rfrtqi6iD0zaAn61F2m4Y'},
                                                               message_id: options[:MsgId]
        return ''
      else
        ''
    end

  end

  #模板消息回调，不关心返回值。
  def self.template_send_job_finish options
    ''
  end


  #用户发送过来消息，回调,只要这里不返回true，则Gem中的值不会被返回。以这里优先级最高。
  def self.text_event content, options

    true
  end

  def self.image_event content, options
    # EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
    #                                                        openid: options[:FromUserName],
    #                                                        message_type: 'text',
    #                                                        data: {:content => '感谢您的参与，坐等好消息吧！'},
    #                                                        message_id: options[:MsgId]
    true
  end

  #浏览事件
  def self.view_event content, options
    true
  end

  #其它事件回调
  def self.another_event options
    true
  end

  #用户自动上报地理位置信息
  def self.auto_location_event options
    true
  end

  def self.scan_event content, options
    case content
      when 'yifengxin_hongbao'
        SelledProductRedpack.delay.send_main_redpack options
      when /yilabao/
        return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                      FromUserName: options[:ToUserName],
                                                                      Content: '你好，欢迎品尝来自U果源的好吃的苹果🍏。

您手上的苹果是U果源直接从果农手中寄出，新鲜健康、无污染，不打腊。

如果觉得味道不错，可直接从下方菜单中购买，感谢您的支持！'
      when /yikao_nianhui_2016/
        return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                      FromUserName: options[:ToUserName],
                                                                      Content: '户外红包领取已结束'

    end
    # EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
    #                                                        openid: options[:FromUserName],
    #                                                        message_type: 'text',
    #                                                        data: {:content => "来自#{options[:EventKey]}的朋友，你好"},
    #                                                        message_id: options[:MsgId]
    return ''
  end

  #获取到经纬度
  def self.location_event options
    # EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
    #                                                        openid: options[:FromUserName],
    #                                                        message_type: 'text',
    #                                                        data: {:content => "快看，你身边有#{2+rand(7)}个小怪兽...,就在#{options[:Label]}附近"},
    #                                                        message_id: options[:MsgId]

    ''
  end


=begin
options 样例
{:ToUserName=>"gh_66b815c2c7c1",
 :FromUserName=>"oE46Bjg-vnjzkkGvA_cr7VO-VD9s",
 :CreateTime=>"1450923945",
 :MsgType=>"event",
 :Event=>"merchant_order",
 :OrderId=>"10268644838038955908",
 :OrderStatus=>"2",
 :ProductId=>"pE46BjpxJ_7k_H_LmIr4uWPQUI2Q",
 :SkuInfo=>"$适应人群:$青年;1075741873:1079742359;1075781223:1079852461"}

如果服务器在5秒之内没有响应，它会再发一次请求过来。所以，必须有缓存介入。
=end
  def self.get_merchant_order options
    # 根据OrderID查找到Order订单信息。然后分配货品信息(selled_products)以及红包分配记录。
    SelledProduct.delay.create_products_by_order_id options[:OrderId]
    # 发首单红包
    SelledProductRedpack.delay.send_first_order_redpack options

    # ::Weixin::Process.delay(:priority => 10).order_tongzhi(options[:OrderId], options)

    Weixin::Xiaodian::Order.delay(:priority => 10).order_tongzhi(options[:OrderId], options)

    return true
  end


  #链接消息
  def self.link_event options
    EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                           openid: options[:FromUserName],
                                                           message_type: 'text',
                                                           data: {:content => "你好，你分享的文章#{options[:Title]}已收到,非常感谢您的分享。"},
                                                           message_id: options[:MsgId]

    ''
  end

  #客服会话结束
  # 这里可用于让用户给客服打分等。
  def self.kv_close_session options
    true
  end

  #客服开始
  def self.kv_create_session options
    true
  end

  def self.message_send_job_finish options
    true
  end

  # 签收回调
  # todo 发反佣等
  def self.order_sign_in order_id
    pp '回调成功'
    CommissionCharge.delay.send_commission_charge order_id

  end


  ##**************  以下非回调函数 ********************************************************

  # 给指定的人发指定金额的红包
  # ::Weixin::Process.now_send_redpack 'o2rYwuANGm7jQs1pNqxvyPy80vjU', '1'
  def self.now_send_redpack openid, mount
    # 一个人只能领一个
    red_pack_options = {}
    red_pack_options[:wishing] = SystemConfig.v('红包活动~祝福语', '祝大家新年平安、幸福')
    red_pack_options[:client_ip] = '101.231.116.38'
    red_pack_options[:act_name] = SystemConfig.v('红包活动~活动名称', '没货了')
    red_pack_options[:remark] = SystemConfig.v('红包活动~备注说明', '祝大家快乐')
    red_pack_options[:send_name] = SystemConfig.v('红包活动~发送者名称', '小神龙创意俱乐部')
    red_pack_options[:re_openid] = openid
    red_pack_options[:total_amount] = mount #金额随机


    openid = "oliNLwN5ggbRmL4g723QVOZ6CfAg"
    red_pack_options = {}
    red_pack_options[:wishing] = '小红包，意思一下，抱歉'
    red_pack_options[:client_ip] = '101.231.116.38'
    red_pack_options[:act_name] = '退款'
    red_pack_options[:remark] = '小红包，意思一下，抱歉'
    red_pack_options[:send_name] = 'U果源'
    red_pack_options[:re_openid] = 'oliNLwN5ggbRmL4g723QVOZ6CfAg'
    red_pack_options[:total_amount] = 100 #金额随机

    redpack_order = EricWeixin::RedpackOrder.create_redpack_order red_pack_options # 发红包


    if redpack_order.class.name == "EricWeixin::RedpackOrder" #发送成功
      pp "给 #{openid} 发红包成功"
    else #发送失败，先记录名称，后续补发
      pp "给 #{openid} 发红包失败，失败原因是："
      pp redpack_order
      redpack_order.to_logger
    end
  end

  # 做api, 用于推送信息 todo
  def self.push_message_to_user openids, message
    openids.split(',').each do |openid|
      EricWeixin::TemplateMessageLog.send_template_message openid: openid,
                                                           template_id: "g5zjxJOrBqKGfvgQvb22Palm_j9qRz3bNlYtVnbQkng",
                                                           topcolor: '#00FF00',
                                                           public_account_id: 1,
                                                           data: {
                                                               first: {value: "提醒"},
                                                               keyword1: {value: 888},
                                                               keyword2: {value: "忽略"},
                                                               keyword3: {value: "忽略"},
                                                               keyword4: {value: "忽略"},
                                                               keyword5: {value: order.created_at.chinese_format},
                                                               remark: {value: message}
                                                           }
    end
  end


end