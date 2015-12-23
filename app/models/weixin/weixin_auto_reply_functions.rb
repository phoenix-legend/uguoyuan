##
#  微信自动回复函数调用。
#  只需要把名字配置到匹配表中即可向用户返回该函数返回的信息。#

module Weixin::WeixinAutoReplyFunctions
  #  测试使用。
  def self.get_last_10_baijiayan options
    articles = ::EricWeixin::Article.last(8)
    ::EricWeixin::ReplyMessage.get_reply_user_message_image_text ToUserName: options[:receive_message][:FromUserName],
                                                                 FromUserName: options[:receive_message][:ToUserName],
                                                                 news: articles
  end

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
end

