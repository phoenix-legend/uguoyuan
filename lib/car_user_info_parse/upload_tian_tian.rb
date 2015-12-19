module UploadTianTian
  # CITY = ["上海", "成都", "深圳", "北京", "南京", "广州", "武汉", "天津", "苏州", "杭州", "东莞", "重庆", "佛山"]

  CITY = ["上海"]

  # 需要上传的数据。
  def self.need_upload_tt
    car_user_infos = UserSystem::CarUserInfo.where "tt_upload_status = 'weishangchuan' and id > #{UserSystem::CarUserInfo::CURRENT_ID} and phone is not null and brand is not null"
    real_user_infos = car_user_infos.select do |car_user_info|
      is_select = true

      if car_user_info.phone.blank?
        is_select = false
      end

      unless car_user_info.note.blank?
        ["诚信", '到店', '精品车', '本公司', '五菱', '提档', '双保险', '可按揭', '该车为', '铲车', '首付', '全顺', '该车', '按揭', '热线', '依维柯'].each do |word|
          if car_user_info.note.include? word
            car_user_info.tt_upload_status = '经销商，不上传'
            car_user_info.save!
            is_select = false
          end
        end
      end

      unless UploadTianTian::CITY.include? car_user_info.city_chinese
        car_user_info.tt_upload_status = '城市不对'
        car_user_info.save!
        is_select = false
      end
      ["0000", "1111", "2222", "3333", "4444", "5555", "6666", "7777", "8888", "9999"].each do |p|
        if car_user_info.phone.include? p
          is_select = false
        end
      end

      ['经理', '总'].each do |name_key|
        is_select = false if car_user_info.name.include? name_key
      end

      # 车价小于1万的，跳过
      unless car_user_info.price.blank?
        car_user_info.price.gsub!('万', '')
        is_select = false if car_user_info.price.to_f <= 1.0
      end
      # 车年龄大于10年的，跳过
      unless car_user_info.che_ling.blank?
        che_ling = car_user_info.che_ling.to_i
        is_select = false if Time.now.year-che_ling>=10
      end

      is_select

    end
    real_user_infos
  end


  def self.update_car_user_info options
    car_user_info = UserSystem::CarUserInfo.find options[:id]
    car_user_info.tt_code = options["code"]
    car_user_info.tt_error = options["error"]
    car_user_info.tt_message = options["message"]
    car_user_info.tt_result = options["result"]
    if car_user_info.tt_code.to_i == 200 and car_user_info.tt_error == "false"
      car_user_info.tt_upload_status = 'success'
    else
      car_user_info.tt_upload_status = 'shibai'
    end
    car_user_info.save!
  end


  def self.for_true_upload_tt2
    while true do
      UploadTianTian.upload_tt2 "7d53d76c30b4fe91b141fe789a967199"
      pp "现在没事了，休息中，等待新数据的出现-----#{Time.now}"
      sleep 30
    end

  end


# UploadTianTian.upload_tt2 "7d53d76c30b4fe91b141fe789a967199"
def self.upload_tt2 ttpai
  begin
    response = RestClient.get 'http://183.61.111.228:4000/api/v1/update_user_infos/get_need_update_tt_info.json'
    infos = JSON.parse response.body
    infos["data"].each do |info|
      next if info["brand"].blank?
      next if info["brand"].blank?
      #             curl 'http://www.ttpai.cn/signup/ttp?name=%E5%BC%A0%E4%B8%89&mobile=13472446647&city=%E4%B8%8A%E6%B5%B7&brand=%E5%AE%9D%E9%A9%AC&source=5-89-659&utmSource=txnews&utmMedium=ttCPA&utmCampaign=1&utmContent=&utmTerm=&joinHmcActivity=0&_=1448502224085&ttpai=1' -H 'Host: www.ttpai.cn' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:42.0) Gecko/20100101 Firefox/42.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3' -H 'Accept-Encoding: gzip, deflate' -H 'Cookie: ttpai=7d53d76c30b4fe91b141fe789a967199; client=223.104.5.234' -H 'Connection: keep-alive'
      tj_response = `curl 'http://www.ttpai.cn/signup/ttp?name=#{CGI::escape(info["name"])}&mobile=13472446647&city=#{CGI::escape(info["city"])}&brand=#{CGI::escape(info["brand"])}&source=5-89-659&utmSource=txnews&utmMedium=ttCPA&utmCampaign=1&utmContent=&utmTerm=&joinHmcActivity=0&_=1448502224085'  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:42.0) Gecko/20100101 Firefox/42.0' -H 'Cookie: ttpai=#{ttpai}'`
      tj_response = JSON.parse tj_response
      pp tj_response
      response_p = RestClient.post 'http://183.61.111.228:4000/api/v1/update_user_infos/update_tt_info.json', code: tj_response["code"],
                                   error: tj_response["error"],
                                   message: tj_response["message"],
                                   result: tj_response["result"],
                                   id: info["id"]
      pp response_p
      pp "做假休息中，假装我现在在录入...#{Time.now}"
      sleep 15
    end
  rescue Exception => e
    pp e
  end
end


# def self.upload_tt
#   car_user_infos = UserSystem::CarUserInfo.where "tt_upload_status = 'weishangchuan' and id > 230776 "
#   car_user_infos.each do |car_user_info|
#     next if car_user_info.phone.blank?
#     is_next = false
#     unless car_user_info.note.blank?
#       ["诚信", '到店', '精品车', '本公司', '五菱', '提档', '双保险', '可按揭', '该车为', '铲车', '首付', '全顺', '该车', '按揭', '热线', '依维柯'].each do |word|
#         if car_user_info.note.include? word
#           is_next = true
#         end
#       end
#     end
#
#     unless UploadTianTian::CITY.include? car_user_info.city_chinese
#       is_next = true
#     end
#
#     ["0000", "1111", "2222", "3333", "4444", "5555", "6666", "7777", "8888", "9999"].each do |p|
#       if car_user_info.phone.include? p
#         is_next = true
#       end
#     end
#
#     ['经理', '总'].each do |name_key|
#       is_next = true if car_user_info.name.include? name_key
#     end
#
#     # 车价小于1万的，跳过
#     unless car_user_info.price.blank?
#       car_user_info.price.gsub!('万', '')
#       is_next = true if car_user_info.price.to_f <= 1.0
#     end
#     # 车年龄大于10年的，跳过
#     unless car_user_info.che_ling.blank?
#       che_ling = car_user_info.che_ling.to_i
#       is_next = true if Time.now.year-che_ling>=10
#     end
#
#     next if is_next
#
#
#     url = "http://www.ttpai.cn/signup/ttp"
#     # para = {
#     #     :name => CGI::escape(car_user_info.name),
#     #     :mobile => car_user_info.phone,
#     #     :city => CGI::escape(car_user_info.city_chinese),
#     #     :brand => CGI::escape(car_user_info.che_xing),
#     #     :source => '5-89-659',
#     #     :utmSource => 'txnews',
#     #     :utmMedium => 'ttCPA',
#     #     :utmCampaign => 1,
#     #     :utmContent => '',
#     #     :utmTerm => '',
#     #     :joinHmcActivity => 0,
#     #     :_ => "#{Time.now.to_i}#{rand(1000)}"
#     # }
#
#     para = {
#         :name => car_user_info.name,
#         :mobile => car_user_info.phone,
#         :city => car_user_info.city_chinese,
#         :brand => car_user_info.che_xing,
#         :source => '5-89-659',
#         :utmSource => 'txnews',
#         :utmMedium => 'ttCPA',
#         :utmCampaign => 1,
#         :utmContent => '',
#         :utmTerm => '',
#         :joinHmcActivity => 0,
#         :_ => "#{Time.now.to_i}#{rand(1000)}"
#     }
#     p = URI.encode_www_form para
#     pp "#{url}?#{p}"
#
#     real_url = "#{url}?#{p}"
#     `curl 'http://m.ttpai.cn/client/?utm_source=txnews&utm_medium=ttCPA&utm_term=&utm_content=&utm_campaign=1&source=5-89-659'`
#     response = `curl '#{real_url}' -H 'Host: www.ttpai.cn' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:42.0) Gecko/20100101 Firefox/42.0' -H 'Accept: */*' -H 'Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3' -H 'Accept-Encoding: gzip, deflate' -H 'Referer: http://m.ttpai.cn/client/?utm_source=txnews&utm_medium=ttCPA&utm_term=&utm_content=&utm_campaign=1&source=5-89-999' -H 'Cookie: client=223.104.211.157; _ga=GA1.2.1868676395.1448423625; utmSource=%7B%22utmSource%22%3A%22txnews%22%2C%22utmMedium%22%3A%22ttCPA%22%2C%22utmCampaign%22%3A%221%22%2C%22utmContent%22%3A%22%22%2C%22utmTerm%22%3A%22%22%7D; ttpai=3e8e6fc2731a9ddb326ca4ccb2b945b4; ttpZoneId=SH_2; ttpZoneHanZi=%E4%B8%8A%E6%B5%B7_%E4%B8%8A%E6%B5%B7; JSESSIONID=4AFC3AD6473952FCA541C5E0CA91447B-n1; _gat=1; _gat_ttpaim=1; _gat_ttpai=1; ttp=%7B%22iv%22%3A%22qpNYYvg37YiiRAH8%2FKL0EQ%3D%3D%22%2C%22v%22%3A1%2C%22iter%22%3A1000%2C%22ks%22%3A128%2C%22ts%22%3A64%2C%22mode%22%3A%22ccm%22%2C%22adata%22%3A%22%22%2C%22cipher%22%3A%22aes%22%2C%22salt%22%3A%22mLNPGC5uGks%3D%22%2C%22ct%22%3A%22%2B%2BZTz8xb2mlej%2BoDyw%3D%3D%22%7D' -H 'Connection: keep-alive'`
#     ec = Encoding::Converter.new("gbk", "UTF-8")
#     response = ec.convert(response)
#     # response = RestClient.get "#{url}?#{p}"
#
#     pp response
#
#     response_json = JSON.parse response
#     car_user_info.tt_code = response_json["code"]
#     car_user_info.tt_error = response_json["error"]
#     car_user_info.tt_message = response_json["message"]
#     car_user_info.tt_result = response_json["result"]
#
#     if car_user_info.tt_code == '200' and car_user_info.tt_error == false
#       car_user_info.tt_upload_status = 'success'
#     end
#     car_user_info.save!
#   end
# end

end
