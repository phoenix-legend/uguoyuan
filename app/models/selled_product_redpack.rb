class SelledProductRedpack < ActiveRecord::Base
  belongs_to :selled_product


  def self.get_left_yikao_redpack

  end

  # 依靠年会发红包，只要扫二维码都可以领取
  def self.send_yikao_redpack openid
      red_pack_options = {}
      red_pack_options[:wishing] = '祝大家年会玩得开心'
      red_pack_options[:client_ip] = '101.231.116.38'
      red_pack_options[:act_name] = 'J.C.户外年会红包'
      red_pack_options[:remark] = '祝大家玩得开心...'
      red_pack_options[:send_name] = 'U果源'
      red_pack_options[:re_openid] = openid
      red_pack_options[:total_amount] = (rand 10) + 100   #金额随机

      # 红包将只会在1月8日和1月9日两天生效
      return 'J.C.户外红包领取已结束' if Date.parse('2016-01-17') < Date.today

      # 依据群里的人数，红包发送241个。
      return '红包已发完' if EricWeixin::WeixinUser.where(phone: '13888889990').count > 245
      # 一个人只能领一个
      current_user = EricWeixin::WeixinUser.where(openid: openid).first
      return '请手下留情，给后面兄弟一些机会' if current_user.phone == '13888889990'

      redpack_order = EricWeixin::RedpackOrder.create_redpack_order red_pack_options # 发红包
      current_user.phone = '13888889990'
      current_user.save!

      if redpack_order.class.name == "EricWeixin::RedpackOrder" #发送成功
        current_user.member_info_id = 55
        current_user.save!
      else  #发送失败，先记录名称，后续补发
        pp "给 #{openid} 发红包失败，失败原因是："
        pp redpack_order
      end
  end

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

  def self.get_bak_redpack_number order_owner_openid
    SelledProductRedpack.where(redpack_type: 'back', order_owner_openid: order_owner_openid, send_status: 0).count
  end

=begin
{:ToUserName=>"gh_66b815c2c7c1",
 :FromUserName=>"oE46Bjjkndd2bYgTdTmlrKjFTqoQ",
 :CreateTime=>"1451372784",
 :MsgType=>"event",
 :Event=>"subscribe",
 :EventKey=>"qrscene_oE46Bjg-vnjzkkGvA_cr7VO-VD9s",
 :Ticket=>
  "gQFR8ToAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xLzduWEwzU1htTFFaVUZFOEZibDNYAAIEF5zyVQMEAAAAAA=="}
=end
  def self.send_bak_redpack options, order_owner_openid
    if options[:is_new] != true
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: "老会员扫描附加红包：").v||"客官，请手下留情，红包留给新来的朋友吧。购买产品后也是可以领红包的。"}

      return
    end

    tuijianren = EricWeixin::WeixinUser.where(openid: order_owner_openid).first
    spr = SelledProductRedpack.where(redpack_type: 'back', order_owner_openid: order_owner_openid, send_status: 0).order(id: :asc).first
    if !spr.blank?
      spr.send_redpack options[:FromUserName]
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: "朋友推荐关注后有红包：").v||"客官，感谢#{tuijianren.nickname}的引见，见面礼已双手奉上。即日起在U果源下单还有首单红包等你来拿！抓紧机会，数量有限。
U果源的水果都来自天然、无污染的农果之家，新鲜健康经济实惠，有任何请咨询微信客服，我们一直都在您身边。"}
    else
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: "朋友推荐关注后无红包：").v||"客官你好，好友#{tuijianren.nickname}的推荐见红包名额已用完。
想和TA一样分享红包吗？即日起在U果源下单还有首单红包等你来拿！
U果源的水果都来自天然、无污染的农果之家，新鲜健康经济实惠，有任何请咨询微信客服，我们一直都在您身边。
"}
    end
  end


  # 发送指定用户的首单红包，发送后再补一条信息。
  # 参数为TX回传回来的参数，直接传过来。
  # 这里会用到两个参数： FromUserName    ToUserName
  def self.send_main_redpack options
    # 发送首次红包
    spr = SelledProductRedpack.where(redpack_type: 'main', order_owner_openid: options[:FromUserName], send_status: 0).first
    public_account = EricWeixin::PublicAccount.where(weixin_number: options[:ToUserName]).first
    if !spr.blank?
      spr.send_redpack options[:FromUserName]
#       EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
#                                                              openid: options[:FromUserName],
#                                                              message_type: 'text',
#                                                              data: {:content => SystemConfig.find_or_create_by!(k: "开箱红包收到后提示：").v||"恭喜你抽到了开箱红包！<a href='#{public_account.host_name_with_schema}/welcome/share_ewm?oid=#{options[:FromUserName]}'>我们还为你准备了分享红包（点击这里领取），叫上好友一起来扫码享惊喜吧</a>！
# U果源为使水果更新鲜、口感更好，尽力保留了水果的原始状态。好吃记得常来呀，有任何需求请在微信中留言，客服小妹将尽快与您沟通。"}

#发送模板信息
      EricWeixin::TemplateMessageLog.send_template_message openid: options[:FromUserName],
                                                           template_id: "e2CPXG1_CUWo9KSClNiooMTvLk8WmyNywaALo-gCuXM",
                                                           topcolor: '#00FF00',
                                                           url: "#{public_account.host_name_with_schema}/welcome/share_ewm?oid=#{options[:FromUserName]}",
                                                           public_account_id: 1,
                                                           data: {
                                                               first: {value: '恭喜你抽到了开箱红包！我们还为你准备了分享红包，点击这里领取吧'},
                                                               keyword1: {value: '随机'},
                                                               keyword2: {value: '3天内'},
                                                               remark: {value: 'U果源为保留更好口感，尽力保留了水果的原始状态。好吃记得常来...'}
                                                           }

    else
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: "开箱红包扫描多次没有红包提示：").v||'抽奖次数已用完...
如果您觉得好吃，记得常来~更多开箱红包等你来抢！
U果源一直在您身边，有需求随时微我哟。'}
    end
  end


  # 发送指定用户的首单红包，发送后再补一条信息。
  # 参数为TX回传回来的参数，直接传过来。
  # 这里会用到两个参数： FromUserName    ToUserName
  # SelledProductRedpack.send_first_order_redpack FromUserName: weixin_user.openid, ToUserName: 'gh_5734a2ca28e5'
  def self.send_first_order_redpack options
    # 发送首单红包
    spr = SelledProductRedpack.where(redpack_type: 'first', order_owner_openid: options[:FromUserName], send_status: 0).first
    if !spr.blank?
      spr.send_redpack options[:FromUserName]
      #发送信息
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: "收到首单红包后文案").v||'首单红包礼物已奉上，非常感谢您的支持。
U果源发货地点一般在略偏远的果园，为了能吃到最新鲜的水果，请耐心等待。
U果源的一路成长离不开您的关注，任何问题请在微信公众账号直接留言，客服将尽快与您沟通。'}
    else
      EricWeixin::MultCustomer.send_customer_service_message weixin_number: options[:ToUserName],
                                                             openid: options[:FromUserName],
                                                             message_type: 'text',
                                                             data: {:content => SystemConfig.find_or_create_by!(k: "订单付款后文案-非首单").v||'您的订单已经收到！这就给您备货...任何问题请在微信公众账号直接留言，客服将尽快与您沟通。'}
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

    redpack_order = EricWeixin::RedpackOrder.create_redpack_order red_pack_options # 发红包

    if redpack_order.class.name == "EricWeixin::RedpackOrder"
      pp "给 #{openid} 发红包完成，金额 #{self.plan_amount}："
      self.really_amount = self.plan_amount
      self.weixin_redpack_id= redpack_order.id
      self.send_status = 1
      self.receive_openid = openid
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
        SystemConfig.find_or_create_by!(k: "redpack_remark_#{self.redpack_type}").v||'别忘了把U果源推荐给好友哦.'
      when 'redpack_send_name'
        SystemConfig.find_or_create_by!(k: "redpack_send_name_#{self.redpack_type}").v||'U果源'
    end
  end
end