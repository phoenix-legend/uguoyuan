class Cms::BaseController < ApplicationController
  before_filter :need_login
  around_filter :round

  def round
    "当前用户的email为：#{current_user.email}".to_logger rescue ''
    "当前用户的id为：#{current_user.id}".to_logger rescue ''
    yield
  end

  def current_user
    return nil if session[:employee_id].blank?
    ::Personal::Employee.find(session[:employee_id])
  end


  alias  current_employee current_user



  def need_login
    redirect_to '/cms/employee_validate/functions/login' if current_user.blank?
    return
  end

end
