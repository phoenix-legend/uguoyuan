class SelledProduct < ActiveRecord::Base
  def self.create_products_by_order_id order_id
    SelledProduct.transaction do
      order = EricWeixin::Xiaodian::Order.where(order_id: order_id).first
      products = SelledProduct.where weixin_xiaodian_order_id: order.id
      return unless products.blank?  # 有时TX会请求过来两次，这里保证每个订单只处理一次。
      order_count = EricWeixin::Xiaodian::Order.where(openid: order.openid).count
      order.product_count.times { |index|
        # 先创建购买的产品
        selled_product = SelledProduct.new weixin_xiaodian_product_id: order.weixin_product_id,
                                           weixin_xiaodian_order_id: order.id,
                                           send_redpack_number: 0,
                                           order_owner_openid: order.openid,
                                           all_redpack_number: 0
        selled_product.save!

        # 再创建红包记录，默认状态是未发送
        # spr_main = SelledProductRedpack.create_selled_product_red_pack selled_product, 'main'
        # spr_back = SelledProductRedpack.create_selled_product_red_pack selled_product, 'back'
        spr_first = SelledProductRedpack.create_selled_product_red_pack selled_product, 'first' if index == 0 && order_count < 2
      }
    end
  end


end