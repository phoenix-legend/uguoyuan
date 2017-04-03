class Wx::Sale::MarketController < Wx::BaseController

  def salesman_performance
    BusinessException.raise '未正确获取授权，获取open_id失败。' if params[:openid].blank?
    @select_salesman = Weixin::WeixinUser.where("self_channel is not null").where(openid: params[:openid]).first
    BusinessException.raise '还不是合作伙伴' if @select_salesman.blank?
    @select_salesman_customers = Weixin::WeixinUser.where(first_register_channel: @select_salesman.self_channel).order(id: :desc)
  end
end