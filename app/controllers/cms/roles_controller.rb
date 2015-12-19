class Cms::RolesController < Cms::BaseController
  before_filter :need_login
  def index
    @roles = ::Personal::Role.all
  end

  def create
    begin
      role = ::Personal::Role.create_role params[:role]
      set_notice '创建角色成功'
    rescue Exception => e
      dispose_exception e
    end
    redirect_to :action => :index
  end

  def edit
    @role = ::Personal::Role.find params[:id]
  end

  def update
    begin
      role = ::Personal::Role.find params[:role_id]
      role.update_role role_params
    rescue Exception => e
      dispose_exception e
    end
    redirect_to :action => :index
  end

  def set_functions
    if request.post?
      begin
        role = ::Personal::Role.find params[:set_function][:role_id]
        role.reset_functions params[:set_function][:function_ids]
        set_notice '设置权限成功'
      rescue Exception => e
        dispose_exception e
      end
      redirect_to :action => :index
      return
    else
      @role = ::Personal::Role.find params[:id]
      @top_functions = Personal::Function.top_functions
    end
  end

  private

  def role_params
    params.require(:role).permit(:name)
  end
end
