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
    url = ::EricWeixin::Snsapi.get_snsapi_base_url url:'/wx/sale/market/salesman_performance/', app_id: pa.weixin_app_id, schema_host: pa.host_name_with_schema
    return ::EricWeixin::ReplyMessage.get_reply_user_message_text ToUserName: options[:receive_message][:FromUserName],
                                                                FromUserName: options[:receive_message][:ToUserName],
                                                                Content: url
  end
end

