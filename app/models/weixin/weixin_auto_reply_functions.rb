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

  # todo 获取到客服口令以后, 以文字形式返回给客服即可。
  # 还需要配置关键字: abc    如果返回的消息包含"unknow-openid", 则不发送任何消息
  # 消息异步发送。

  def self.get_kf_kouling_insurance_tgy options
    # pp options
    # {:ToUserName => "gh_5734a2ca28e5", :FromUserName => "oliNLwN5ggbRmL4g723QVOZ6CfAg",
    #  :CreateTime => "1491190248", :MsgType => "text", :Content => "kfkouling", :MsgId => "6404613347679903130"}

    Weixin::WeixinAutoReplyFunctions.delay.get_kf_kouling_insurance_tgy_action options

    return ''
  end

  def self.get_kf_kouling_insurance_tgy_action options
    content = options[:receive_message][:Content]
    openid = options[:receive_message][:FromUserName]

    weixin_user = EricWeixin::WeixinUser.where(openid: openid).first
    nickname = weixin_user.nickname

    city = content.split(/,|，/)[1]
    url = "http://che.uguoyuan.cn/api/v1/update_user_infos/get_kouling_for_kefu?openid=#{openid}&nickname=#{CGI::escape  nickname}&city=#{CGI::escape  city||''}"
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


end

