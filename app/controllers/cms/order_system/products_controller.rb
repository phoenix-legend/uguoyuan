class Cms::OrderSystem::ProductsController < Cms::BaseController
  before_filter :need_login

  def new
    session_content = get_session_content params[:session_content_id]
    pp session_content
    if session_content.blank?
      @name = ''
      @description = ['']
      @cover_image = ''
      @url = ''
      @online = false
    else
      @name = session_content[:name]
      @description = eval(session_content[:description]) rescue ''
      @cover_image = session_content[:cover_image]
      @url = session_content[:url]
      @online = session_content[:online] == '1'
      @sort_by = session_content[:sort_by]
      @app_name = session_content[:app_name]
      @android_app_url = session_content[:android_app_url]
      @return_page = session_content[:return_page]
      @price = session_content[:price]
      @iphone_app_url = session_content[:iphone_app_url]
      @sale_number = session_content[:sale_number]
      @adds_words = session_content[:adds_words]
    end
  end

  def create
    begin
      # BusinessException.raise 'xxx'
      params[:description] = params[:description].to_s unless params[:description].blank?
      params[:cover_image] = upload_file params[:cover_image] unless params[:cover_image].blank?
      params[:detail_image] = upload_file params[:detail_image] unless params[:detail_image].blank?
      ::OrderSystem::Product.create_product params.permit(:return_page, :adds_words, :price, :sale_number, :iphone_app_url, :android_app_url, :name, :description, :cover_image, :detail_image, :url, :online, :sort_by, :app_name)
      redirect_to '/cms/order_system/products'
    rescue Exception=>e
      dispose_exception e
      params.delete(:cover_image)
      params.delete(:detail_image)
      redirect_to({action: :new, session_content_id: set_session_content }, alert: get_notice_str)
    end
  end

  def update
    begin
      # BusinessException.raise 'xxx'
      @product = ::OrderSystem::Product.find_by_id(params[:id])
      params[:description] = params[:description].to_s unless params[:description].blank?
      params[:cover_image] = upload_file params[:cover_image] unless params[:cover_image].blank?
      params[:detail_image] = upload_file params[:detail_image] unless params[:detail_image].blank?
      @product.update_product params.permit(:return_page, :adds_words, :price, :sale_number, :iphone_app_url, :android_app_url, :name, :description, :cover_image, :detail_image, :url, :online, :sort_by, :app_name)
      redirect_to '/cms/order_system/products'
    rescue Exception=> e
      dispose_exception e
      params.delete(:cover_image)
      params.delete(:detail_image)
      flash[:alert] = get_notice_str
      redirect_to "/cms/order_system/products/#{@product.id.to_s}/edit", session_content_id: set_session_content
    end
  end

  def index
    @products = ::OrderSystem::Product.all
  end

  def edit
    session_content = get_session_content params[:session_content_id]
    if session_content.blank?
      @product = ::OrderSystem::Product.find_by_id(params[:id])
      @name = @product.name
      d = eval(@product.description) rescue ['']
      @description = d.blank? ? [''] : d
      @cover_image = @product.cover_image
      @detail_image = @product.detail_image
      @url = @product.url
      @online = @product.online
      @sort_by = @product.sort_by
      @app_name = @product.app_name
      @android_app_url = @product.android_app_url
      @return_page = @product.return_page
      @iphone_app_url = @product.iphone_app_url
      @sale_number = @product.sale_number
      @price = @product.price
      @adds_words = @product.adds_words
    else
      @product = ::OrderSystem::Product.find_by_id(session_content[:id])
      @name = session_content[:name]
      @description = session_content[:description]
      @cover_image = session_content[:cover_image]
      @url = session_content[:url]
      @online = session_content[:online] == "1"
      @sort_by = session_content[:sort_by]
      @app_name = session_content[:app_name]
      @android_app_url = session_content[:android_app_url]
      @return_page = session_content[:return_page]
      @iphone_app_url = session_content[:iphone_app_url]
      @sale_number = session_content[:sale_number]
      @price = session_content[:price]
      @adds_words = session_content[:adds_words]
    end
  end

  private
    def upload_file name
      return '' if name.blank?
      uploaded_io = name
      dir = 'images'
      prefix = 'image'
      new_name = ''
      index = 1
      origin_name_with_path = Rails.root.join('public', 'uploads/' + dir, uploaded_io.original_filename)
      File.open(origin_name_with_path, 'wb') do |file|
        file.write(uploaded_io.read)
        new_name = prefix + Time.now.to_s(:number) + index.to_s + File.extname(file)
        new_name_with_path = Rails.root.join('public', 'uploads/' + dir, new_name)
        File.rename(origin_name_with_path, new_name_with_path)
        index += 1
      end
      new_name
    end
end