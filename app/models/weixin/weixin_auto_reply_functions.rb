##
#  微信自动回复函数调用。
#  只需要把名字配置到匹配表中即可向用户返回该函数返回的信息。#
module Weixin::WeixinAutoReplyFunctions
  def self.test_emplate_message options
    public_account = ::EricWeixin::PublicAccount.find_by_weixin_number options[:receive_message][:ToUserName]
    ::EricWeixin::TemplateMessageLog.send_template_message openid: options[:receive_message][:FromUserName],
                                                           template_id: "fz50PHl9P6lGU0Ow5FY2RMX1WukEsX2DaCDgMbmnmeg",
                                                           topcolor: '#00FF00',
                                                           url: 'www.baidu.com',
                                                           data: {
                                                               first: {value: 'xx'},
                                                               keyword1: {value: '王小明'},
                                                               keyword2: {value: '001-002-001'},
                                                               keyword3: {value: '陈小朋'},
                                                               keyword4: {value: '小明同学今天上课表现很别棒，很认真。手工都自己做的，依恋家长比较严重。'},
                                                               keyword5: {value: '总体来讲还很不错，心理上缺乏安全感，需要家长多陪同。'},
                                                               remark: {value: ''}
                                                           },
                                                           public_account_id: public_account.id
    return ''
  end

  # {:key_word=>"订单",
  # :receive_message=>
  #      {:ToUserName=>"gh_66b815c2c7c1",
  #       :FromUserName=>"oE46BjsgNP4NbxQ2qSKT2R-tgDV4",
  #       :CreateTime=>"1458637054",
  #       :MsgType=>"text",
  #       :Content=>"订单",
  #       :MsgId=>"6264798444067460276"}}
  #   待检查 ， 小朋做的发提成功能
  def self.self_related_users_and_orders options
    pp "xxxx"*100
    pp options

    pa = ::EricWeixin::PublicAccount.get_public_account_by_name 'ugy'
    url = ::EricWeixin::Snsapi.get_snsapi_base_url url: '/wx/sale/market/salesman_performance/', app_id: pa.weixin_app_id, schema_host: pa.host_name_with_schema
    return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:receive_message][:FromUserName],
                                                                  FromUserName: options[:receive_message][:ToUserName],
                                                                  Content: url
  end


  # 还需要配置关键字: abc    如果返回的消息包含"unknow-openid", 则不发送任何消息
  # 消息异步发送。
  def self.get_kf_kouling_insurance_tgy options
    # pp options
    # {:ToUserName => "gh_5734a2ca28e5", :FromUserName => "oliNLwN5ggbRmL4g723QVOZ6CfAg",
    #  :CreateTime => "1491190248", :MsgType => "text", :Content => "kfkouling", :MsgId => "6404613347679903130"}

    Weixin::WeixinAutoReplyFunctions.delay.get_kf_kouling_insurance_tgy_action options

    return ''
  end


  #与爬虫网站相结合, 通过输入城市口令,来获取58拿不到手机号的卖车线索。
  def self.get_kf_kouling_insurance_tgy_action options
    content = options[:receive_message][:Content]
    openid = options[:receive_message][:FromUserName]

    weixin_user = EricWeixin::WeixinUser.where(openid: openid).first
    nickname = weixin_user.nickname

    city = content.split(/,|，/)[1]
    url = "http://che.uguoyuan.cn/api/v1/update_user_infos/get_kouling_for_kefu?openid=#{openid}&nickname=#{CGI::escape nickname}&city=#{CGI::escape city||''}"
    response = RestClient.get url
    pp response
    response = response.body
    response = JSON.parse(response)
    kouling = if response["data"]["kouling"].blank?
                ''
              else
                response["data"]["kouling"]
              end

    EricWeixin::MultCustomer.send_customer_service_message weixin_number: "gh_5734a2ca28e5", #公众号weixin number, 参考public accounts表
                                                           openid: openid,
                                                           message_type: 'text',
                                                           data: {:content => kouling},
                                                           message_id: options[:MsgId]
  end


  def self.be_agency options
    pp options
    Weixin::WeixinAutoReplyFunctions.delay.be_agency_act options
    return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:receive_message][:FromUserName],
                                                                  FromUserName: options[:receive_message][:ToUserName],
                                                                  Content: SystemConfig.v('发送我要分享后即时回复', '正在生成您的专用二维码,请稍后...')

    # return ''
    ''
  end

  # todo 发送我要当代理
  # 发送8张图片
  # 发送二维码的链接
  # 给用户表添加列:  代理标记,成为代理时间,上家的openid
  # 订单表增加: 超时确认收货时间(考虑到预售), 是否已签收, 签收时间, 增加签收回调
  # 创建新表: 佣金表: id, order_id,  预计佣金发放时间, 发放是否成功, 实际发放时间, 超时发放时间,   发放金额
  # 定时任务: 发放佣金, 预售超时时间增加60天, 待手工设置。 普通超时时间14天。
  # 保留首单红包, 暂停扫码红包和推荐红包

  def self.be_agency_act options
    # 金煌芒图片
    mongo_pics = {
        # 'QH-v2WNZTxGMY9gYtYRtf4W6aSJFQCmh0Qh1R-K2G0o' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtfwLBN8vg8TNeVmoe6_YTvMY' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtf04NXoVEuOr93ft8twuFXjw' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtf-9AqYtDTHgZEEwnL5OOaUc' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtfxeSVQfY7zH7uIYyK6iB7EY' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtf3vIGfpANmlaVFDs-bLLLaI' => '金煌芒',
        # "QH-v2WNZTxGMY9gYtYRtf1yuBNJNpq-B_54FPsRBlDA" => '金煌芒',
        # "QH-v2WNZTxGMY9gYtYRtf8L7qb-GoBOdSMsTuGnh5jc" => '金煌芒',
        # "QH-v2WNZTxGMY9gYtYRtf-pYbRL54-MOJGNM5GKbpFo" => '金煌芒'

        # 'QH-v2WNZTxGMY9gYtYRtfxKrinI3jx3s_8bom1mV1fM' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtf063CWbZba4QXG1f7vGHiNI' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtf6Ad3Z6r_4Ejf7tqVf-4yIk' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtf8B_sy0R_As3hNJcrwbkMg8' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtf8rJlo9aRxvs9zkNH7nlSVk' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtf-WIZEmEAJ4RHRtaVScr3gc' => '金煌芒',
        # 'QH-v2WNZTxGMY9gYtYRtf7sV8GAFTi9m6_vwSWgklBM' => '金煌芒',


    }
    agency_ewm_url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxaa334fd34be16fca&redirect_uri=http%3A%2F%2Fwww.uguoyuan.cn%2Feric_weixin%2Fweixin%2Fsnsapi%3Fweixin_app_id%3Dwxaa334fd34be16fca%26url%3DaHR0cDovL3d3dy51Z3VveXVhbi5jbi93ZWxjb21lL2FnZW50X2V3bT9hPTE%3D&response_type=code&scope=snsapi_base&state=abc#wechat_redirect"
    weixin_user = EricWeixin::WeixinUser.where(openid: options[:receive_message][:FromUserName]).first

    mongo_pics.keys.each do |pic_mediaid|
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: "gh_5734a2ca28e5", #公众号weixin number, 参考public accounts表
                                                             openid: options[:receive_message][:FromUserName],
                                                             message_type: 'image',
                                                             data: {:media_id => pic_mediaid},
                                                             message_id: options[:MsgId]
      sleep 1
    end
    sleep 1
    EricWeixin::MultCustomer.send_customer_service_message weixin_number: "gh_5734a2ca28e5", #公众号weixin number, 参考public accounts表
                                                           openid: options[:receive_message][:FromUserName],
                                                           message_type: 'text',
                                                           data: {:content => "<a href='#{agency_ewm_url}'>#{SystemConfig.v("推广专用二维码下载链接文字", '点击这里获取您的专用分享二维码')}</a>"},
                                                           message_id: options[:MsgId]


    # 如果已经是代理,以下逻辑就不用走了。 反正图已经发下去了
    return if weixin_user.agency_flg == true

    weixin_user.agency_flg = true
    weixin_user.agency_time = Time.now
    weixin_user.save!

    return ''
  end


  # {:key_word=>\"芒果视频\", :receive_message=>{:ToUserName=>\"gh_5734a2ca28e5\", :FromUserName=>\"oliNLwIZc495Q_-Zzzos2X7yiZ38\", :CreateTime=>\"1598757276\", :MsgType=>\"text\", :Content=>\"芒果视频\", :MsgId=>\"22888698279295682\"}}
  def self.send_maongguo_video options
    openid = options[:receive_message][:FromUserName]
    video_id = 'QH-v2WNZTxGMY9gYtYRtf6AjssswEsbJ_DSqKu_Xbl8'
    EricWeixin::MultCustomer.send_customer_service_message weixin_number: "gh_5734a2ca28e5", #公众号weixin number, 参考public accounts表
                                                           openid: openid,
                                                           message_type: 'video',
                                                           data: {:media_id => video_id},
                                                           message_id: 1
    return ''
  end


  #发送代理业绩
  def self.agency_yeji options
    Weixin::WeixinAutoReplyFunctions.delay.agency_yeji_act options
    return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:receive_message][:FromUserName],
                                                                  FromUserName: options[:receive_message][:ToUserName],
                                                                  Content: SystemConfig.v('查看代理业绩立即回复', '请稍等,业绩正在统计中...')

  end

  def self.agency_yeji_act options
    openid = options[:receive_message][:FromUserName]


    today_agency_number = Weixin::WeixinUser.where("subscribe = 1 and agency_openid = ? and agency_time >= ? and agency_time <= ?", openid, "#{Date.today.strftime("%Y-%m-%d")} 00:00:00", "#{Date.today.strftime("%Y-%m-%d")} 23:59:59").count

    all_agency_number = Weixin::WeixinUser.where("subscribe = 1 and agency_openid = ? ", openid).count

    agency_openids = Weixin::WeixinUser.where("subscribe = 1 and agency_openid = ? ", openid).collect &:openid


    today_order_number = Weixin::Xiaodian::Order.joins("left join weixin_users on weixin_users.openid = weixin_xiaodian_orders.openid").
        where("weixin_users.agency_openid  in (?) and weixin_xiaodian_orders.created_at >= ? and weixin_xiaodian_orders.created_at <= ?", agency_openids,
              "#{Date.today.strftime("%Y-%m-%d")} 00:00:00", "#{Date.today.strftime("%Y-%m-%d")} 23:59:59").count

    yesterday_order_number = Weixin::Xiaodian::Order.joins("left join weixin_users on weixin_users.openid = weixin_xiaodian_orders.openid").
        where("weixin_users.agency_openid  in (?) and weixin_xiaodian_orders.created_at >= ? and weixin_xiaodian_orders.created_at <= ?", agency_openids,
              "#{Date.yesterday.strftime("%Y-%m-%d")} 00:00:00", "#{Date.yesterday.strftime("%Y-%m-%d")} 23:59:59").count

    all_order_number = Weixin::Xiaodian::Order.joins("left join weixin_users on weixin_users.openid = weixin_xiaodian_orders.openid").
        where("weixin_users.agency_openid  in (?) ", agency_openids).count

    today_orders = Weixin::Xiaodian::Order.joins("left join weixin_users on weixin_users.openid = weixin_xiaodian_orders.openid").
        where("weixin_users.agency_openid  in (?) and weixin_xiaodian_orders.created_at >= ? and weixin_xiaodian_orders.created_at <= ?", agency_openids,
              "#{Date.today.strftime("%Y-%m-%d")} 00:00:00", "#{Date.today.strftime("%Y-%m-%d")} 23:59:59").
        group("weixin_users.agency_openid").
        select("weixin_users.agency_openid as agency_openid, count(*) as c")

    yesterday_orders = Weixin::Xiaodian::Order.joins("left join weixin_users on weixin_users.openid = weixin_xiaodian_orders.openid").
        where("weixin_users.agency_openid  in (?) and weixin_xiaodian_orders.created_at >= ? and weixin_xiaodian_orders.created_at <= ?", agency_openids,
              "#{Date.yesterday.strftime("%Y-%m-%d")} 00:00:00", "#{Date.yesterday.strftime("%Y-%m-%d")} 23:59:59").
        group("weixin_users.agency_openid").
        select("weixin_users.agency_openid as agency_openid, count(*) as c")


    str = "您今日新增代理#{today_agency_number}个, 合计有效代理数量#{all_agency_number}个。\n
今日新增订单#{today_order_number}个, 总订单数#{all_order_number}个。\n
今日订单分布(共#{today_order_number}个):"
    today_orders.each do |order|
      next if order.c == 0
      user = Weixin::WeixinUser.where("openid = ?", order.agency_openid).first
      s = "\n#{user.nickname} #{order.c}个"
      str << s
    end



    str << " \n\n昨日订单分布(共#{yesterday_order_number}个):"

    yesterday_orders.each do |order|
      next if order.c == 0
      user = Weixin::WeixinUser.where("openid = ?", order.agency_openid).first
      s = "\n#{user.nickname} #{order.c}个"
      str << s
    end

    pp str



    EricWeixin::MultCustomer.send_customer_service_message weixin_number: "gh_5734a2ca28e5", #公众号weixin number, 参考public accounts表
                                                           openid: openid,
                                                           message_type: 'text',
                                                           data: {:content => str},
                                                           message_id: options[:MsgId]
  end


end

