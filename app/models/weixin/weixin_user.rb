class Weixin::WeixinUser < EricWeixin::WeixinUser

  def xiaodian_apple_orders
    Weixin::Xiaodian::Order.where(openid: openid) #.where "product_name like ?", "%#{SystemConfig.v( 'ticheng_product_name_key', '红富士' )}%"
  end


  def agency
    users = Weixin::WeixinUser.where(openid: self.agency_openid).first
    # users.first
  end


end

# {"button":[
#
#
#     {
#     "name":"芒果季",
#     "sub_button":[
#       {"name":"烟台大樱桃", "type":"view", "url":"http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwMvt00suQ5cbef4AmfQXWIk&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect"} ,
#       {"name":"红枣~好吃到没朋友", "type":"view", "url":"http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwG5ekElQ5m-lq27la09s_dk&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect"},
#       {"name":"纯蜂蜜~未加工", "type":"view", "url":"http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwCrCHl7hzyGyfO2ITJVM3lw&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect"},
#       {"name":"大芒果", "type":"view", "url":"http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwBYnizIrZChYBKeAH7lP--8&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect"}
#       ]
#      },
#
#     {"name":"水果百科",
#     "sub_button":[
#     {"name":"关于苹果打腊", "type":"view", "url":"http://mp.weixin.qq.com/s/Ol_51aZx1uMOqoM3FlYqGg"}
#     ]
#     },
#
#
#     {"name":"关于售后",
#     "sub_button":[
#     {"name":"订单查看", "type":"view", "url":"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxaa334fd34be16fca&redirect_uri=http%3A%2F%2Fwww.uguoyuan.cn%2Feric_weixin%2Fweixin%2Fsnsapi%3Fweixin_app_id%3Dwxaa334fd34be16fca%26url%3DL2VyaWNfd2VpeGluL3dlaXhpbi9vcmRlcnM%2FYT0x&response_type=code&scope=snsapi_base&state=abc#wechat_redirect"},
#     {"name":"售后联系", "type":"click", "key":"shouhoudescript"}
#     ]
#     }
#
# ]}