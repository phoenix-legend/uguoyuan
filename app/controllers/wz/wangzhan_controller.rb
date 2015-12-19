class Wz::WangzhanController < ApplicationController

  around_filter :round
  def round
    pp request.env["HTTP_USER_AGENT"]
    Thread.current[:template_name] =  session[:template_name]
    Thread.current[:qudao_name] = session[:qudao_name]
    Thread.current[:ip] = get_ip
    yield
  end

end
