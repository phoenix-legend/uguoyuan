class BaseMailer < ActionMailer::Base
  # default from: '379576382@qq.com'
  default from: 'noreply@ikidstv.com'
  default charset: "utf-8"
  default content_type: "text/html"
end