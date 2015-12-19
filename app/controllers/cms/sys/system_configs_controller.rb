class Cms::Sys::SystemConfigsController < Cms::BaseController
  before_filter :need_login
  before_action :set_system_config, only: [:show, :edit, :update, :destroy]


  def index
    @system_config = SystemConfig.all
  end


  def show

  end


  def new
    @system_config = SystemConfig.new
  end


  def edit
  end


  def create
    begin
      @system_config = SystemConfig.create!(system_config_params)
      flash[:success] = '成功创建自定义配置信息！'
      redirect_to  :action => :show, :id =>@system_config.id
    rescue Exception => e
      dispose_exception e
      @system_config = SystemConfig.new(system_config_params)
      flash.now[:alert] = get_notice_str
      render :new
    end
  end


  def update
    begin
      @system_config = SystemConfig.find(params[:id])
      @system_config.update!(system_config_params)
      flash[:success] = '成功修改自定义配置信息！'
      redirect_to  :action => :show, :id =>@system_config.id
    rescue Exception => e
      dispose_exception e
      @system_config = SystemConfig.find(params[:id])
      @system_config.attributes = system_config_params
      flash.now[:alert] = get_notice_str
      render :edit
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_config
      @system_config = SystemConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def system_config_params
      params.require(:system_config).permit(:k, :v)
    end
end
