class OrderSystem::Template < ActiveRecord::Base
  has_many :templates_products, :class_name => '::OrderSystem::TemplatesProducts', foreign_key: 'template_id'
  has_many :products, :class_name => '::OrderSystem::Product', through: :templates_products

  validates_presence_of :show_name, message: 'show_name不能为空。'
  validates_presence_of :real_name, message: 'real_name不能为空。'
  validates_uniqueness_of :real_name, message: 'real_name重复'



  def valid_template_products
    template_products = self.templates_products.where(online: true).order(sort_by: :desc)
  end



  # {"show_name"=>"1",
  #     "real_name"=>"2",
  #     "products"=>
  #     {"1"=>
  #          {"select"=>"1",
  #           "sort_by"=>"3",
  #           "online"=>"1",
  #           "cover_image"=>"tao_0623_1"},
  #      "2"=>
  #          {"select"=>"1",
  #           "sort_by"=>"4",
  #           "online"=>"1",
  #           "cover_image"=>"tao_0623_2"},
  #      "4"=>
  #          {"select"=>"1",
  #           "sort_by"=>"5",
  #           "online"=>"1",
  #           "cover_image"=>"tao_0623_3"}}}

  def self.create_template options
    self.transaction do
      pp "&&&&&&&&&&&&&&&&&&&&&&&&& options &&&&&&&&&&&&&&&&&&&&&&&&&"
      pp options
      product_options = options[:products]
      options = get_arguments_options options, [:show_name, :real_name]
      template = self.new options
      template.save!
      template.reload
      product_options.each do |p|
        next if p.second["select"].blank?
        t_p = ::OrderSystem::TemplatesProducts.new
        t_p.template = template
        t_p.product = ::OrderSystem::Product.find(p.first)
        t_p.sort_by = p.second["sort_by"].to_i rescue 0
        t_p.online = p.second["online"] == "1"
        unless p.second["cover_image"].blank?
          file_name = self.upload_file p.second["cover_image"]
          t_p.cover_image = file_name
        end
        t_p.save!
      end unless product_options.blank?
    end
  end

  def update_template options
    self.transaction do
      pp "&&&&&&&&&&&&&&&&&&&&&&&&& options &&&&&&&&&&&&&&&&&&&&&&&&&"
      pp options
      product_options = options[:products]
      options = ::OrderSystem::Template.get_arguments_options options, [:show_name, :real_name]
      self.update! options
      self.reload
      product_options.each do |p|
        if p.second["select"].blank?
          t_p = ::OrderSystem::TemplatesProducts.where(product_id: p.first, template_id: self.id).first
          t_p.destroy! unless t_p.blank?
        else
          t_p = ::OrderSystem::TemplatesProducts.where(product_id: p.first, template_id: self.id).first
          t_p = ::OrderSystem::TemplatesProducts.new if t_p.blank?
          t_p.template = self
          t_p.product = ::OrderSystem::Product.find(p.first)
          t_p.sort_by = p.second["sort_by"].to_i rescue 0
          t_p.online = p.second["online"] == "1"
          unless p.second["cover_image"].blank?
            file_name = ::OrderSystem::Template.upload_file p.second["cover_image"]
            t_p.cover_image = file_name
          end
          t_p.save!
        end
      end unless product_options.blank?
    end
  end

end