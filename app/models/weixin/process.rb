class ::Weixin::Process
  #用户订阅回调
  def self.subscribe options, is_new
    event_key = if options[:EventKey].match /qrscene_/
                  options[:event_key][8..1000]
                else
                  options[:EventKey]
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
      when 'qrscene_yifengxin_hongbao'
        SelledProductRedpack.send_main_redpack options
    end
    # EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
    #                                                        openid: options[:FromUserName],
    #                                                        message_type: 'text',
    #                                                        data: {:content => "来自#{options[:EventKey]}的朋友，你好"},
    #                                                        message_id: options[:MsgId]
    true
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
=end
  def self.get_merchant_order options
    # 根据OrderID查找到Order订单信息。然后分配货品信息(selled_products)以及红包分配记录。
    SelledProduct.create_products_by_order_id options[:OrderId]
    # 发首单红包
    SelledProductRedpack.send_first_order_redpack options
    true
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