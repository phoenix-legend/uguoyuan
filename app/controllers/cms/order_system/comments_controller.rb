class Cms::OrderSystem::CommentsController < Cms::BaseController

  def index
    @product = ::OrderSystem::Product.find_by_id(params[:product_id])
    if @product.blank?
      flash[:alert] = "请给出正确的产品信息。"
      redirect_to '/cms/order_system/products'
      return
    end
    @comments = @product.comments.order(:sort_by).paginate(page: params[:page], per_page: params[:per_page]||5)
  end

  def new
    @product = ::OrderSystem::Product.find_by_id(params[:product_id])
    if @product.blank?
      flash[:alert] = "请给出正确的产品信息。"
      redirect_to '/cms/order_system/products'
      return
    end
    @comment = ::OrderSystem::Comment.new product_id: @product.id
  end

  def edit
    @comment = ::OrderSystem::Comment.find_by_id(params[:id])
    if @comment.blank?
      flash[:alert] = '请指定正确的评论。'
      redirect_to '/cms/order_system/products'
      return
    end
  end

  def create
    begin
      comment = ::OrderSystem::Comment.create_comment comment_params
      flash[:success] = "评论创建成功。"
      redirect_to "/cms/order_system/comments?product_id=#{comment.product_id}"
    rescue Exception=> e
      dispose_exception e
      flash[:alert] = get_notice_str
      redirect_to "/cms/order_system/comments/new?product_id=#{params[:product_id]}&session_content_id=#{set_session_content}"
    end
  end

  def update
    begin
      comment = ::OrderSystem::Comment.find_by_id(params[:id])
      if comment.blank?
        flash[:alert] = '请指定正确的评论。'
        redirect_to '/cms/order_system/products'
        return
      end
      comment.update_comment comment_params
      flash[:success] = "评论更新成功。"
      redirect_to "/cms/order_system/comments?product_id=#{comment.product_id}"
    rescue Exception=>e
      dispose_exception e
      flash[:alert] = get_notice_str
      redirect_to "/cms/order_system/comments/#{params[:id]}/edit?session_content_id=#{set_session_content}"
    end
  end

  def destroy
    comment = ::OrderSystem::Comment.find_by_id(params[:id])
    if comment.blank?
      flash[:alert] = '请指定正确的评论。'
      redirect_to '/cms/order_system/products'
      return
    end
    product_id = comment.product_id
    begin
      comment.destroy_self
      flash[:success] = '删除成功。'
      redirect_to "/cms/order_system/comments?product_id=#{product_id}"
    rescue Exception=>e
      dispose_exception e
      flash[:alert] = get_notice_str
      redirect_to "/cms/order_system/comments?product_id=#{product_id}"
    end
  end

  private
  def comment_params
    params.permit(:product_id, :nick_name, :city, :phone, :sex, :content, :comment_time, :sort_by)
  end


  def require_comment
    comment = ::OrderSystem::Comment.find_by_id(params[:id])
    if comment.blank?
      flash[:alert] = '请指定正确的评论。'
      redirect_to '/cms/order_system/products'
      return
    end
    comment
  end
end