class WelcomeController < ApplicationController

  def index
    render layout: false
  end

  def share_ewm
    # 根据openid生成相应的二维码，并展现。
    public_account = EricWeixin::PublicAccount.where(name: 'ugy').first
    weixin_user = EricWeixin::WeixinUser.where(openid: params[:oid]).first

    @num = SelledProductRedpack.get_bak_redpack_number weixin_user.openid

    code = ::EricWeixin::TwoDimensionCode.get_long_time_two_dimension_code app_id: public_account.weixin_app_id, scene_str: weixin_user.openid
    @url = code.image_url
  end

  #销售代理二维码展示
  def agent_ewm
    public_account = EricWeixin::PublicAccount.where(name: 'ugy').first
    weixin_user = EricWeixin::WeixinUser.where(openid: params[:openid]).first
    code = ::EricWeixin::TwoDimensionCode.get_long_time_two_dimension_code app_id: public_account.weixin_app_id, scene_str: "sale-agent-#{weixin_user.openid}"
    @url = code.image_url
  end


end
