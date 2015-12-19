class OrderSystem::Product < ActiveRecord::Base
  has_many :templates_products, :class_name => '::OrderSystem::TemplatesProducts', foreign_key: 'product_id'
  has_many :templates, :class_name => '::OrderSystem::Template', through: :templates_products
  has_many :comments, -> {order "sort_by desc"}

  has_many :orders, :class_name => '::OrderSystem::Order'

  validates_presence_of :name, message: "产品名称不可以为空。"
  validates_presence_of :cover_image, message: "产品图片不可以为空。"
  scope :online, ->{ where online: true }

  def valid_comments
    self.comments.sort(sort_by: :desc)
  end

  def self.create_product options
    options = get_arguments_options options, [:return_page, :adds_words, :price, :sale_number, :iphone_app_url, :android_app_url, :name, :description, :url, :cover_image, :detail_image, :online, :sort_by, :app_name]
    self.transaction do
      product = self.new options
      product.save!
      product.reload
      product
    end
  end

  def update_product options
    options = self.class.get_arguments_options options, [:return_page, :adds_words, :price, :sale_number, :iphone_app_url, :android_app_url, :name, :description, :url, :cover_image, :detail_image, :online, :sort_by, :app_name]
    options[:online] = options[:online] == '1'
    options.delete(:cover_image) if options[:cover_image].blank?
    options.delete(:detail_image) if options[:detail_image].blank?
    ::OrderSystem::Product.transaction do
      self.update_attributes! options
      self
    end

  end
end