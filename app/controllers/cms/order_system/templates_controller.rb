class Cms::OrderSystem::TemplatesController < Cms::BaseController

  def index
    @templates = ::OrderSystem::Template.paginate(page: params[:page], per_page: params[:per_page]||5)
  end

  def new
    @template = ::OrderSystem::Template.new
    @products = ::OrderSystem::Product.online
  end

  def edit
    @template = ::OrderSystem::Template.find(params[:id])
    @products = ::OrderSystem::Product.online
  end

  def create
    begin
      ::OrderSystem::Template.create_template template_params
      redirect_to action: :index, notice: "模板创建成功。"
    rescue Exception=> e
      dispose_exception e
      flash[:alert] = get_notice_str
      params[:products].each do |k,v|
        v.delete("cover_image")
      end
      redirect_to action: :new, session_content_id: set_session_content
    end
  end

  def update
    begin
      ::OrderSystem::Template.find(params[:id]).update_template template_params
      redirect_to action: :index, notice: "模板更新成功。"
    rescue Exception=>e
      dispose_exception e
      flash[:alert] = get_notice_str
      params[:products].each do |k,v|
        v.delete("cover_image")
      end
      redirect_to "/cms/order_system/templates/#{params[:id]}/edit?session_content_id=#{set_session_content}"
    end
  end

  private
    def template_params
      params.permit(:show_name, :real_name, products: [:select, :sort_by, :online, :cover_image])
    end

end