class Weixin::WeixinUser < EricWeixin::WeixinUser
    # 绑定会员
    def self.member_login(options)
      openid = options[:openid]
      name = options[:name]
      password = options[:password]

      self.transaction do
        member_info = MemberInfo.login name, password, ''
        weixin_user = self.find_by_openid(openid)
        #todo 如果不存在，则调用创建方法，使该用户存在
        BusinessException.raise '该微信用户不存在' if weixin_user.blank?

        weixin_user.member_info = member_info
        weixin_user.save!
        weixin_user.reload
        weixin_user
      end
    end
  # 通过客服接口发信息，尝试给所有人发信息,提醒用户参加活动。
  def self.try_send_all_users
    message = SystemConfig.find_by_k('remind_message')
    BusinessException.raise '数据库提示信息没有配。' if message.blank?
    public_account = ::EricWeixin::PublicAccount.find_by_name 'ddc'
    users = public_account.weixin_users
    users.each do |user|
      EricWeixin::MultCustomer.send_customer_service_message(app_id: public_account.weixin_app_id,
                                                             openid: user.openid,
                                                             message_type: 'text',
                                                             weixin_number: public_account.weixin_number,
                                                             data: {:content => message.v}) rescue ''
    end unless users.blank?
  end
end
