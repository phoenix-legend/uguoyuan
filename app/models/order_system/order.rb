class OrderSystem::Order < ActiveRecord::Base
  belongs_to :product, :class_name => '::OrderSystem::Product'
  belongs_to :user_info, :class_name => '::UserSystem::UserInfo'

  OrderStatus = {0 => '未处理', 1 => '已处理'}

  validates_presence_of :product, message: "产品不存在。"
  validates_presence_of :user_info, message: "客户不存在。"

  def self.create_order options
      options = get_arguments_options options, [:product_id, :user_info_id]
      order = self.new options
      order.status= 0
      order.save!
      order.reload
      order
  end

end