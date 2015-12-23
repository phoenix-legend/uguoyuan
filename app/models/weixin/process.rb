class ::Weixin::Process
  #用户订阅回调
  def self.subscribe options, is_new
    "subscribe.......".to_logger
    pp "********************** 关注后  options **********************"
    pp options
    # "********************** 关注后  options **********************"
    # {:ToUserName=>"gh_66b815c2c7c1",
    #  :FromUserName=>"oE46BjsgNP4NbxQ2qSKT2R-tgDV4",
    #  :CreateTime=>"1441963133",
    #  :MsgType=>"event",
    #  :Event=>"subscribe",
    #  :EventKey=>"qrscene_oE46Bjg-vnjzkkGvA_cr7VO-VD9s",
    #  :Ticket=>
    #      "gQFR8ToAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xLzduWEwzU1htTFFaVUZFOEZibDNYAAIEF5zyVQMEAAAAAA=="}
    user = EricWeixin::WeixinUser.find_by_openid(options[:FromUserName])
    money_status = SystemConfig.find_or_create_by!(k: 'money_status')
    p_red_pack_number = SystemConfig.find_or_create_by!(k: 'red_pack_number')
    red_pack_number = p_red_pack_number.v.to_i
    if !options[:EventKey].blank? && !options[:EventKey].match( /qrscene_/ ).blank? && user && is_new
      if red_pack_number <= 0
        # EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
          SendCustomerServiceMessageJob.perform_later weixin_number: options[:ToUserName],
                                                               openid: options[:FromUserName],
                                                               message_type: 'text',
                                                               data: {:content => SystemConfig.find_or_create_by!(k: 'red_pack_empty').v||'对不起，红包已经领完。下一波红包即将扑面而来。'},
                                                               message_id: options[:MsgId]
      else
        scene_id = options[:EventKey][8..100].to_i
        return true if scene_id>19999999 || scene_id<10000000
        recommand_weixin_user_id = scene_id-10000000
        recommand_weixin_user_openid = EricWeixin::WeixinUser.find_by_id(recommand_weixin_user_id).openid

        # ================必填参数===================
        # re_openid
        # total_amount
        # wishing
        # client_ip
        # act_name
        # remark
        # send_name

        red_pack_options = {}
        red_pack_options[:wishing] = SystemConfig.find_or_create_by!(k: 'redpack_wishing').v||'合家欢乐，万事如意'
        red_pack_options[:client_ip] = '101.231.116.38'
        red_pack_options[:act_name] = SystemConfig.find_or_create_by!(k: 'redpack_act_name').v||'关注送1元活动'
        red_pack_options[:remark] = SystemConfig.find_or_create_by!(k: 'redpack_remark').v||'别忘了分享给朋友哟。'
        red_pack_options[:send_name] = SystemConfig.find_or_create_by!(k: 'redpack_send_name').v||"小神龙创意俱乐部"

        # 关注后获得一元
        red_pack_options1 = red_pack_options.dup
        red_pack_options1[:re_openid] = options[:FromUserName]
        red_pack_options1[:total_amount] = rand(10)+100

        # SendRedPackJob.perform_later(
        #     red_pack_options1[:wishing],
        #     red_pack_options1[:client_ip],
        #     red_pack_options1[:act_name],
        #     red_pack_options1[:remark],
        #     red_pack_options1[:send_name],
        #     red_pack_options1[:re_openid],
        #     red_pack_options1[:total_amount]
        # )

        SendRedPackJob.perform_later red_pack_options1
        red_pack_number -= 1
        p_red_pack_number.v = red_pack_number.to_s
        p_red_pack_number.save!
        # result1 = EricWeixin::RedpackOrder.create_redpack_order red_pack_options1

        if red_pack_number > 0
          # 给推荐人发送红包
          red_pack_options2 = red_pack_options.dup
          red_pack_options2[:re_openid] = recommand_weixin_user_openid
          red_pack_options2[:total_amount] = rand(10)+100
          pp "********************* 给推荐人发送红包时参数 ***************************"
          pp red_pack_options2

          SendRedPackJob.perform_later red_pack_options2
          red_pack_number -= 1
          p_red_pack_number.v = red_pack_number.to_s
          p_red_pack_number.save!
          # result2 = EricWeixin::RedpackOrder.create_redpack_order red_pack_options2
        end

        # if result1 == "NOTENOUGH" || result2 == "NOTENOUGH"
        #   money_status.v = 0
        #   money_status.save!
        # elsif result1.class.to_s == 'EricWeixin::RedpackOrder' && result2.class.to_s == 'EricWeixin::RedpackOrder'
        if red_pack_number > 0
          # EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
          SendCustomerServiceMessageJob.perform_later weixin_number: options[:ToUserName],
                                                                 openid: options[:FromUserName],
                                                                 message_type: 'text',
                                                                 data: {:content => "再领红包，点击<a href='#{SystemConfig.find_or_create_by(k: 'domain').v}/weixin/activities/qr_code?openid=#{options[:FromUserName]}'>此页面</a>分享给好友，识别二维码后，双方可再次得红包。"},
                                                                 message_id: options[:MsgId]
          SendCustomerServiceMessageJob.perform_later weixin_number: options[:ToUserName],
                                                                 openid: recommand_weixin_user_openid,
                                                                 message_type: 'text',
                                                                 data: {:content => "再领红包，点击<a href='#{SystemConfig.find_or_create_by(k: 'domain').v}/weixin/activities/qr_code?openid=#{recommand_weixin_user_openid}'>此页面</a>,分享给好友，识别二维码后，双方再次得红包。"},
                                                                 message_id: options[:MsgId]
        end
        # end
      end
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
    "click_event.......".to_logger
    if SystemConfig.find_or_create_by!(k: 'money_status').v == '1'
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => "点击<a href='#{SystemConfig.find_or_create_by(k: 'domain').v}/weixin/activities/qr_code?openid=#{options[:FromUserName]}'>此页面</a>,分享给好友，识别二维码后，双方立即得红包。"},
                                                             message_id: options[:MsgId]
    else
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: 'red_pack_empty').v},
                                                             message_id: options[:MsgId]
    end
    ''
  end

  #模板消息回调，不关心返回值。
  def self.template_send_job_finish options
    ''
  end


  #用户发送过来消息，回调,只要这里不返回true，则Gem中的值不会被返回。以这里优先级最高。
  def self.text_event content, options
    if content == '刘晓琦'
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => '刘晓琦，你好，收到了你的消息'},
                                                             message_id: options[:MsgId]

      return ''
    elsif content == '我要找客服。'

      return ''
    end
    true
  end

  def self.image_event content, options
    EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                           openid: options[:FromUserName],
                                                           message_type: 'text',
                                                           data: {:content => '感谢您的参与，坐等好消息吧！'},
                                                           message_id: options[:MsgId]
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
    # EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
    #                                                        openid: options[:FromUserName],
    #                                                        message_type: 'text',
    #                                                        data: {:content => "来自#{options[:EventKey]}的朋友，你好"},
    #                                                        message_id: options[:MsgId]
    true
  end

  #获取到经纬度
  def self.location_event options
    EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                           openid: options[:FromUserName],
                                                           message_type: 'text',
                                                           data: {:content => "快看，你身边有#{2+rand(7)}个小怪兽...,就在#{options[:Label]}附近"},
                                                           message_id: options[:MsgId]

    ''
  end

  def self.get_merchant_order options
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