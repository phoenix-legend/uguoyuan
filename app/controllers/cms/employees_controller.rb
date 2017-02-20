class Cms::EmployeesController < Cms::BaseController
  before_filter :need_login
  def index
    @employees = ::Personal::Employee.all
  end

  def show
    @employee = ::Personal::Employee.find(params[:id])
    @functions = @employee.functions
  end

  def new
    operator = current_employee
    @employee = ::Personal::Employee.new
    @organizations = ::Personal::Organization.permitted(operator)
  end

  def edit
    @employee = ::Personal::Employee.find(params[:id])
    @organizations = ::Personal::Organization.all
  end

  def create
    begin
      @employee = ::Personal::Employee.create_employee(current_employee, employee_params)
    rescue Exception => e
      dispose_exception e
    end
    redirect_to cms_employee_path(@employee)

  end

  def update
    begin
      @employee = ::Personal::Employee.update_employee(params[:id], employee_params)
      redirect_to cms_employee_path(@employee)
    rescue Exception => e
      dispose_exception e
      redirect_to edit_cms_employee_path(params[:id])
    end

  end

  def set_role
    if request.post?
      begin
        employee = ::Personal::Employee.find params[:set_role][:employee_id]
        employee.reset_roles params[:set_role][:role_ids]
        set_notice '设置角色成功'
      rescue Exception => e
        dispose_exception e
      end
      redirect_to action: :index
    else
      @employee = ::Personal::Employee.find params[:id]
      @roles = ::Personal::Role.all
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:experience_center_id, :status, :email, :work_number, :birthday, :first_work_date, :entry_date, :password, :real_name, :password_confirmation, :organization_ids => [])
  end
end
