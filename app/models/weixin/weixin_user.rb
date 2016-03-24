class Weixin::WeixinUser < EricWeixin::WeixinUser

  def xiaodian_apple_orders
    Weixin::Xiaodian::Order.where(openid: openid)#.where "product_name like ?", "%#{SystemConfig.v( 'ticheng_product_name_key', '红富士' )}%"
  end
end


a = {
    "button" => [
        {"name" => "苹果大脆甜",
         "sub_button" => [
             {
                 "name" => "运城红富士/12个装/小琦家的",
                 "type" => "view",
                 "url" => 'http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwNbltMdxy_6im5pmeDNWrYs&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect'
             },
             {
                 "name" => "红枣~好吃到没朋友",
                 "type" => "view",
                 "url" => "http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwG5ekElQ5m-lq27la09s_dk&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect"
             }
         ]
        },

        {
            "name" => "团购~越便宜",
            "sub_button" => [
                {
                    "name" => "团购在这里",
                    "type" => "view",
                    "url" => "https://shop14465664.koudaitong.com/v2/showcase/goods?alias=2op2jno3wg2nc&sf=wx_sm&from=singlemessage&isappinstalled=0"
                }
            ]
        },


        {"name" => "订单看过来",
         "sub_button" => [
             {
                 "name" => "点这里",
                 "type" => "view",
                 "url" => 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxaa334fd34be16fca&redirect_uri=http%3A%2F%2Fwww.uguoyuan.cn%2Feric_weixin%2Fweixin%2Fsnsapi%3Fweixin_app_id%3Dwxaa334fd34be16fca%26url%3DL2VyaWNfd2VpeGluL3dlaXhpbi9vcmRlcnM%2FYT0x&response_type=code&scope=snsapi_base&state=abc#wechat_redirect'
             },
             {
                 "name" => "团购订单点这里",
                 "type" => "view",
                 "url" => 'https://shop14465664.koudaitong.com/v2/showcase/goods?alias=2op2jno3wg2nc&sf=wx_sm&from=singlemessage&isappinstalled=0'
             }

         ]
        }
    ]
}