class OrderSystem::TemplatesProducts < ActiveRecord::Base
  belongs_to :template, :class_name => '::OrderSystem::Template'
  belongs_to :product, :class_name => '::OrderSystem::Product'

  validates_uniqueness_of :template_id, scope: :product_id, message: '重复。'

end