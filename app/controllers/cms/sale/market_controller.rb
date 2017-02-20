class Cms::Sale::MarketController < Cms::BaseController
  before_filter :need_login
  def salesman_performance
    @salesman = Weixin::WeixinUser.where("self_channel is not null")
    @select_salesman = if params[:self_channel].blank?
                        @salesman.first
                       else
                         Weixin::WeixinUser.where(self_channel: params[:self_channel]).first
                       end
    @select_salesman_customers = if @select_salesman.blank?
                                   Weixin::WeixinUser.where("1=2")
                                 else
                                   Weixin::WeixinUser.where(first_register_channel: @select_salesman.self_channel).order(id: :desc)
                                 end
  end
end