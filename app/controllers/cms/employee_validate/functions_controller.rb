class Cms::EmployeeValidate::FunctionsController < Cms::BaseController

  before_filter :need_login, :except => [:welcome, :login]

  def index
    render :layout => false
  end

  def list
    @functions = ::Personal::Function.all
  end

  def welcome
    # render :layout=>false
  end

  def new
    @parents = ::Personal::Function.parent_functions
  end

  def edit
    @function = ::Personal::Function.find params[:id]
    @parents = ::Personal::Function.parent_functions
  end

  def update2
    begin
      function = ::Personal::Function.find params[:function][:id]
      function.update_function params[:function].permit(:title, :parent_id, :page_url, :description)
      set_notice '更新功能点成功'
    rescue Exception => e
      dispose_exception e
    end
    redirect_to :action => 'list'
  end

  def create
    begin
      ::Personal::Function.create_function params[:function]
      set_notice '创建功能成功'
      redirect_to :action => :list
    rescue Exception => e
      dispose_exception e
      redirect_to :action => :new
    end
  end

  def menu
    render :layout => false
  end

  def login
    if request.post?
      begin
        employee = ::Personal::Employee.login params[:email], params[:password]
        session[:employee_id] = employee.id
        redirect_to action: 'index'
        return
      rescue Exception => e
        dispose_exception e
        flash.now[:alert] = get_notice_str
      end
    end
    render :layout => false
  end

  def logout
    session[:employee_id] = nil
    redirect_to '/cms/employee_validate/functions/login'
  end

  def modify_password
    if request.post?
      begin
        ::Personal::Employee.find(session[:employee_id]).modify_password params
        set_notice '密码修改成功'
        redirect_to :action => :modify_password
      rescue Exception => e
        dispose_exception e
        redirect_to :action => :modify_password
      end
    end
  end

  private
  def function_params
    params.require(:function).permit(:title, :parent_id, :page_url, :description, :model_name, :method_name)
  end
end
