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


    # 处理朋友推荐，一般会用openid做为二维码参数，所以长度一般会在25位以上，先使用位数过滤一遍，可减少数据库查询负载。
    if event_key.length > 25
      weixin_user = EricWeixin::WeixinUser.where(openid: event_key).first
      SelledProductRedpack.delay.send_bak_redpack options, weixin_user.openid unless weixin_user.blank?
      return true
    end

    # 处理用户扫一封信二维码进来的情况...   如果您觉得好吃，记得常来~更多开箱红包等你来抢！ U果源一直在您身边，有需求随时微我哟。
    case event_key
      when /yifengxin_hongbao/
        EricWeixin::MultCustomer.delay.send_customer_service_message weixin_number: options[:ToUserName],
                                                                     openid: options[:FromUserName],
                                                                     message_type: 'text',
                                                                     data: {:content => '购买完成以后，使用订购者微信扫此二维码领取开箱红包。'}
      when /yikao_nianhui_2016/
        EricWeixin::MultCustomer.delay.send_customer_service_message weixin_number: options[:ToUserName],
                                                                     openid: options[:FromUserName],
                                                                     message_type: 'text',
                                                                     data: {:content => 'U果源，把新鲜水果从果园直接送到您的手中。
这里没有批发商，没有工业腊，没有催熟剂，没有门面费用，只有最原始新鲜的水果，来这里就对了。
年会的苹果，就来自U果源...对，就是这样的，大，脆，甜。
'}
        pp '依靠2016年会红包群发功能'

        openid = options[:FromUserName]
        if Date.parse('2016-01-09') > Date.today
          return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                        FromUserName: options[:ToUserName],
                                                                        Content: '依靠户外红包领取未开始'

        end

        if Date.parse('2016-01-09') < Date.today
          return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                        FromUserName: options[:ToUserName],
                                                                        Content: '依靠户外红包领取已结束'
        end


        # 依据群里的人数，红包发送241个。
        left_hb = EricWeixin::WeixinUser.where(phone: '13888889999').count
        if left_hb > 245
          return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                        FromUserName: options[:ToUserName],
                                                                        Content: '红包已发完'
        end
        # 一个人只能领一个
        current_user = EricWeixin::WeixinUser.where(openid: openid).first
        if current_user.phone == '13888889999'
          return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                        FromUserName: options[:ToUserName],
                                                                        Content: "请手下留情，给后面兄弟一些机会, 红包已发送#{left_hb}个，总共245个"
        end

        SelledProductRedpack.delay.send_yikao_redpack openid # 发红包
        return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                      FromUserName: options[:ToUserName],
                                                                      Content: "红包正在排队发送，请稍安勿燥, 红包已发送#{left_hb}个，总共245个"
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
    ''
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
      when /yikao_nianhui_2016/
        pp '依靠2016年会红包群发功能'

        openid = options[:FromUserName]
        if Date.parse('2016-01-05') > Date.today
          return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                        FromUserName: options[:ToUserName],
                                                                        Content: '依靠户外红包领取未开始'

        end

        if Date.parse('2016-01-09') < Date.today
          return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                        FromUserName: options[:ToUserName],
                                                                        Content: '依靠户外红包领取已结束'
        end


        # 依据群里的人数，红包发送241个。

        left_hb = EricWeixin::WeixinUser.where(phone: '13888889999').count
        if left_hb > 241
          return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                        FromUserName: options[:ToUserName],
                                                                        Content: '红包已发完'
        end
        # 一个人只能领一个
        current_user = EricWeixin::WeixinUser.where(openid: openid).first
        if current_user.phone == '13888889999'
          return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                        FromUserName: options[:ToUserName],
                                                                        Content: "请手下留情，给后面兄弟一些机会, 红包已发送#{left_hb}个，总共241个"
        end

        SelledProductRedpack.delay.send_yikao_redpack openid # 发红包
        return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:FromUserName],
                                                                      FromUserName: options[:ToUserName],
                                                                      Content: "红包正在排队发送，请稍安勿燥, 红包已发送#{left_hb}个，总共241个"
    end
    # EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
    #                                                        openid: options[:FromUserName],
    #                                                        message_type: 'text',
    #                                                        data: {:content => "来自#{options[:EventKey]}的朋友，你好"},
    #                                                        message_id: options[:MsgId]
    return 'hello'
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

这个接口有些变态，如果服务器在5秒之内没有响应，它会再发一次请求过来。所以，必须有缓存介入。
=end
  def self.get_merchant_order options
    # 根据OrderID查找到Order订单信息。然后分配货品信息(selled_products)以及红包分配记录。
    SelledProduct.delay.create_products_by_order_id options[:OrderId]
    # 发首单红包
    SelledProductRedpack.delay.send_first_order_redpack options
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


end