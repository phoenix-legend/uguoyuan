class OrderSystem::Comment < ActiveRecord::Base
  belongs_to :product

  SEX={1=>'男', 0=>'女'}
  validates_presence_of :product, message: "评论必须关联一个产品。"
  validates_presence_of :nick_name, message: "请填写昵称。"
  validates_presence_of :city, message: "请填写所在城市。"
  # validates_format_of :phone, :with => EricTools::RegularConstants::MobilePhone, message: '手机号格式不正确', allow_blank: false
  validates_presence_of :content, message: "请填写评论内容。"
  validates_presence_of :comment_time, message: "请填写评论时间。"
  validates_presence_of :phone, message: "请填写手机号。"



  def self.create_comment options
    options = get_arguments_options options, [:product_id, :nick_name, :city, :phone, :sex, :content, :comment_time, :sort_by], sex: 1
    self.transaction do
      comment = self.new options
      comment.save!
      comment.reload
      comment
    end
  end

  def update_comment options
    options = ::OrderSystem::Comment.get_arguments_options options, [:product_id, :nick_name, :city, :phone, :sex, :content, :comment_time, :sort_by], sex: 1
    self.transaction do
      options = options.delete_if{|k,v | v.blank?}
      self.update! options
      self.reload
      self
    end
  end

  def destroy_self
    ::OrderSystem::Comment.transaction do
      self.destroy!
    end
  end

end