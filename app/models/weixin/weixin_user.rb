class Weixin::WeixinUser < EricWeixin::WeixinUser

  def xiaodian_apple_orders
    Weixin::Xiaodian::Order.where(openid: openid) #.where "product_name like ?", "%#{SystemConfig.v( 'ticheng_product_name_key', '红富士' )}%"
  end


  def agency
    users = Weixin::WeixinUser.find_by_openid self.agency_openid
    users.first
  end


end

# 苹果的链接: http://mp.weixin.qq.com/s?__biz=MzIyNjE0OTc4Mg==&mid=2651564265&idx=2&sn=f70f6512f056a02ba4c31ba340ca92f5&chksm=f38bdc10c4fc550662cbf94638e808804b950a7a028d4cf14ed56ec2dde622509068f6abe811&scene=0#wechat_redirect


# aa = {"button":[{"name":"苹果大脆甜", "sub_button":[ {"name":"红枣~好吃到没朋友", "type":"view", "url":"http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwG5ekElQ5m-lq27la09s_dk&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect"}, {"name":"纯蜂蜜~未加工", "type":"view", "url":"http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwCrCHl7hzyGyfO2ITJVM3lw&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect"}]}, {"name":"订单看过来", "sub_button":[{"name":"订单点这里", "type":"view", "url":"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxaa334fd34be16fca&redirect_uri=http%3A%2F%2Fwww.uguoyuan.cn%2Feric_weixin%2Fweixin%2Fsnsapi%3Fweixin_app_id%3Dwxaa334fd34be16fca%26url%3DL2VyaWNfd2VpeGluL3dlaXhpbi9vcmRlcnM%2FYT0x&response_type=code&scope=snsapi_base&state=abc#wechat_redirect"}, {"name":"科普一下", "type":"view", "url":"http://mp.weixin.qq.com/mp/homepage?__biz=MzIyNjE0OTc4Mg==&hid=1&sn=8a3a0ff3ea5b2548b0215d98e1c31bfd#wechat_redirect"}]}, {"name":"朋友们的店", "sub_button":[{"name":"川藏精品/吃货天堂", "type":"view", "url":"https://h5.koudaitong.com/v2/showcase/homepage?kdt_id=17326391&reft=1476706490077&spm=g301348950&kdtfrom=wxd&form=singlemessage"}]}]}
# k = JSON.parse aa
#
# k = {
#     "button" => [
#         {"name" => "苹果大脆甜", "sub_button" => [
#             {"name" => "红枣~好吃到没朋友", "type" => "view", "url" => "http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwG5ekElQ5m-lq27la09s_dk&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect"},
#             {"name" => "纯蜂蜜,未加工", "type" => "view", "url" => "http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwErxa5LjeS6exZJUTBM5Pd8&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect"}]
#         },
#
#         {"name" => "订单看过来", "sub_button" => [
#             {"name" => "订单点这里", "type" => "view", "url" => "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxaa334fd34be16fca&redirect_uri=http%3A%2F%2Fwww.uguoyuan.cn%2Feric_weixin%2Fweixin%2Fsnsapi%3Fweixin_app_id%3Dwxaa334fd34be16fca%26url%3DL2VyaWNfd2VpeGluL3dlaXhpbi9vcmRlcnM%2FYT0x&response_type=code&scope=snsapi_base&state=abc#wechat_redirect"},
#             {"name" => "科普一下", "type" => "view", "url" => "http://mp.weixin.qq.com/mp/homepage?__biz=MzIyNjE0OTc4Mg==&hid=1&sn=8a3a0ff3ea5b2548b0215d98e1c31bfd#wechat_redirect"}]
#         },
#
#         {"name" => "朋友们的店", "sub_button" => [
#             {"name" => "川藏精品/吃货天堂", "type" => "view", "url" => "https://h5.koudaitong.com/v2/showcase/homepage?kdt_id=17326391&reft=1476706490077&spm=g301348950&kdtfrom=wxd&form=singlemessage"}]
#         }
#     ]
# }
#
#
# a = {
#     "button" => [
#         {"name" => "苹果大脆甜",
#          "sub_button" => [
#              {
#                  "name" => "运城红富士/12个装/小琦家的",
#                  "type" => "view",
#                  "url" => 'http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwNbltMdxy_6im5pmeDNWrYs&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect'
#              },
#              {
#                  "name" => "红枣~好吃到没朋友",
#                  "type" => "view",
#                  "url" => "http://mp.weixin.qq.com/bizmall/malldetail?id=&pid=pliNLwG5ekElQ5m-lq27la09s_dk&biz=MzIyNjE0OTc4Mg==&scene=&action=show_detail&showwxpaytitle=1#wechat_redirect"
#              }
#          ]
#         },
#
#         {
#             "name" => "团购~越便宜",
#             "sub_button" => [
#                 {
#                     "name" => "团购在这里",
#                     "type" => "view",
#                     "url" => "https://shop14465664.koudaitong.com/v2/showcase/goods?alias=2op2jno3wg2nc&sf=wx_sm&from=singlemessage&isappinstalled=0"
#                 }
#             ]
#         },
#
#
#         {"name" => "订单看过来",
#          "sub_button" => [
#              {
#                  "name" => "点这里",
#                  "type" => "view",
#                  "url" => 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxaa334fd34be16fca&redirect_uri=http%3A%2F%2Fwww.uguoyuan.cn%2Feric_weixin%2Fweixin%2Fsnsapi%3Fweixin_app_id%3Dwxaa334fd34be16fca%26url%3DL2VyaWNfd2VpeGluL3dlaXhpbi9vcmRlcnM%2FYT0x&response_type=code&scope=snsapi_base&state=abc#wechat_redirect'
#              },
#              {
#                  "name" => "团购订单点这里",
#                  "type" => "view",
#                  "url" => 'https://shop14465664.koudaitong.com/v2/showcase/goods?alias=2op2jno3wg2nc&sf=wx_sm&from=singlemessage&isappinstalled=0'
#              }
#
#          ]
#         }
#     ]
# }