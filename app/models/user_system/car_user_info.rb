class UserSystem::CarUserInfo < ActiveRecord::Base
  require 'rest-client'
  require 'pp'

  CURRENT_ID = 235632

  EMAIL_STATUS = {0 => '待导', 1 => '已导', 2 => '不导入'}
  CHANNEL = {'che168' => 'yy-huayang-141219-012', 'taoche' => 'yy-huayang-141219-011'}
  ALL_CITY = {"441900" => "东莞", "440600" => "佛山", "440100" => "广州",
              "440300" => "深圳", "370100" => "济南", "370200" => "青岛", "330100" => "杭州", "330200" => "宁波",
              "330300" => "温州", "320100" => "南京", "320500" => "苏州", "320200" => "无锡", "130100" => "石家庄",
              "130200" => "唐山", "410100" => "郑州", "110100" => "北京", "210200" => "大连", "210100" => "沈阳",
              "310100" => "上海", "500100" => "重庆", "350100" => "福州", "350200" => "厦门", "420100" => "武汉",
              "430100" => "长沙", "230100" => "哈尔滨", "610100" => "西安", "510100" => "成都", "140100" => "太原",
              "120100" => "天津", "340100" => '合肥'}

  #城市所对应的拼音。 主要用于从淘车网更新数据。
  PINYIN_CITY = {"dongguan" => "东莞", "foshan" => "佛山", "guangzhou" => "广州", "shenzhen" => "深圳", "jinan" => "济南", "qingdao" => "青岛", "hangzhou" => "杭州", "ningbo" => "宁波", "wenzhou" => "温州", "nanjing" => "南京", "suzhou" => "苏州", "wuxi" => "无锡", "shijiazhuang" => "石家庄", "tangshan" => "唐山", "zhengzhou" => "郑州", "beijing" => "北京", "dalian" => "大连", "shenyang" => "沈阳", "shanghai" => "上海", "chongqing" => "重庆", "fuzhou" => "福州", "xiamen" => "厦门", "wuhan" => "武汉", "changsha" => "长沙", "haerbin" => "哈尔滨", "xian" => "西安", "chengdu" => "成都", "taiyuan" => "太原", "tianjin" => "天津", "chongqing" => "重庆"}
  #好车需要上传的城市
  IMPORTENT_CITY = ["北京", "成都", "大连", "东莞", "福州", "广州", "杭州", "重庆", "南京", "宁波", "青岛", "上海", "沈阳", "苏州", "天津", "温州", "武汉", "西安", "哈尔滨"]

  SI_CHENGSHI = ['上海', '无锡', '苏州', '南京']

  def self.create_car_user_info options
    user_infos = UserSystem::CarUserInfo.where detail_url: options[:detail_url]
    return 1 if user_infos.length > 0

    car_user_info = UserSystem::CarUserInfo.new options
    car_user_info.save!
    return 0
  end

  def self.send_email
    ::UserSystem::CarUserInfoSendEmail.transaction do
      #晚上不发邮件
      return if Time.now.hour < 9
      return if Time.now.hour > 21
      # 同一个小时不发两次邮件
      return if ::UserSystem::CarUserInfoSendEmail.had_send_email_in_current_hour?

      send_car_user_infos = self.need_send_mail_car_user_infos

      # 若需发送的数据量为0，则不发送邮件
      return if send_car_user_infos.blank?

      success_count = send_car_user_infos.count { |info| !info.bookid.blank? }
      cunzai_count = send_car_user_infos.count { |info| info.upload_status == 'yicunzai' and info.bookid.blank? }
      shibai_count = send_car_user_infos.count { |info| info.upload_status == 'shibai' }
      budaoru_count = send_car_user_infos.count { |info| info.upload_status == 'weidaoru' }

      zhuti = "#{success_count}成功#{cunzai_count}存在#{shibai_count}失败#{budaoru_count}不导"

      # 发送邮件
      if Time.now > Time.parse("#{Time.now.chinese_format_day} 21:00:00")
        MailSend.send_car_user_infos('chenkai@baohe001.com;tanguanyu@baohe001.com;yuanyuan@baohe001.com',
                                     '13472446647@163.com',
                                     send_car_user_infos.count,
                                     zhuti,
                                     [self.generate_xls_of_car_user_info(send_car_user_infos), self.generate_xls_of_four_city]
        ).deliver
        # path , data = self.generate_xls_of_hv_h6
        # unless path.blank?
        #   MailSend.send_car_user_infos('5396230@qq.com',
        #                                '13472446647@163.com',
        #                                data.count,
        #                                '哈弗H6数据',
        #                                [path]
        #   ).deliver
        # end

      else
        MailSend.send_car_user_infos('chenkai@baohe001.com;tanguanyu@baohe001.com;yuanyuan@baohe001.com',
                                     '13472446647@163.com',
                                     send_car_user_infos.count,
                                     zhuti,
                                     [self.generate_xls_of_car_user_info(send_car_user_infos)]
        ).deliver
      end

      send_car_user_infos.each { |u| u.update email_status: 1 }
      # 发完邮件，将对应的车主信息的邮件状态置为已发(1)
      ''
    end

  end

  # UserSystem::CarUserInfo.get_haoche_sessionkey_and_yanzhengma
  def self.get_haoche_sessionkey_and_yanzhengma
    session_key = "#{Time.now.to_i}#{rand(10000000)}"
    # return session_key, ''
    url = "http://gw2.pahaoche.com/wghttp/randomImageServlet?Rand=4&sessionKey=#{session_key}"
    response = RestClient.get url
    `rm #{Rails.root}/public/downloads/*`
    file = File.new("#{Rails.root}/public/downloads/#{session_key}.jpg", 'wb')
    file.write response.body
    file.flush
    file.close
    file_name = file.path


    code = if Rails.env == "development"
             `tesseract #{file_name} stdout --tessdata-dir /Applications/OCRTOOLS.app/Contents/Resources/tessdata`
           else
             `/usr/local/bin/tesseract #{file_name} stdout`
           end


    code = code.strip
    pp code
    if code.blank?
      pp '获取验证码失败'
      return '333333', session_key
    end
    code_match = code.match /\A(\d{4})\Z/
    puts '获取'

    if code_match
      return code_match[1], session_key
    else
      sleep 1
      return UserSystem::CarUserInfo.get_haoche_sessionkey_and_yanzhengma
    end
    code
  end


  # UserSystem::CarUserInfo.upload_to_haoche
  def self.upload_to_haoche
    car_user_infos = UserSystem::CarUserInfo.where "(upload_status = 'weidaoru' or (upload_status = 'shibai' and shibaiyuanyin = 'AuthCode is Wrong--E013')) and id > #{UserSystem::CarUserInfo::CURRENT_ID} and fabushijian > '2015-11-24'"

    car_user_infos.each do |car_user_info|
      next if car_user_info.phone.blank?
      is_next = false
      unless car_user_info.note.blank?
        ["诚信", '到店', '精品车', '本公司', '五菱', '提档', '双保险', '可按揭', '该车为', '铲车', '首付', '全顺', '该车', '按揭', '热线', '依维柯'].each do |word|
          if car_user_info.note.include? word
            is_next = true
          end
        end
      end

      ["0000", "1111", "2222", "3333", "4444", "5555", "6666", "7777", "8888", "9999"].each do |p|
        if car_user_info.phone.include? p
          is_next = true
        end
      end

      ['经理', '总'].each do |name_key|
        is_next = true if car_user_info.name.include? name_key
      end

      unless car_user_info.price.blank?
        car_user_info.price.gsub!('万', '')
        is_next = true if car_user_info.price.to_f <= 1.0
      end

      unless car_user_info.che_ling.blank?
        che_ling = car_user_info.che_ling.to_i
        is_next = true if Time.now.year-che_ling>=10
      end

      next if is_next

      code, session_key = UserSystem::CarUserInfo.get_haoche_sessionkey_and_yanzhengma
      url = "http://gw2.pahaoche.com/wghttp/internal/appointment"

      channel = if ::UserSystem::CarUserInfo::IMPORTENT_CITY.include? car_user_info.city_chinese
                  ::UserSystem::CarUserInfo::CHANNEL[car_user_info.site_name]
                else
                  'yy-aiyi-150513'
                end


      para = {
          :sessionKey => session_key,
          :authCode => code,
          :from => 'GW',
          :expectTime => '计划卖车时间:一周内',
          :name => car_user_info.name,
          :mobile => car_user_info.phone,
          :city => car_user_info.city_chinese,
          :_ => session_key,
          :channel => channel,
      }
      car_user_info.channel = channel
      #不同的城市提交到不同的地方
      if ::UserSystem::CarUserInfo::IMPORTENT_CITY.include? car_user_info.city_chinese

        para.merge!({
                        :tokenKey => '8891E237-C4DB-4B79-A7A2-77DBB50D0779',
                        :tokenValue => '3b783617-8bf6-4f03-ab11-7c6f46054ad2',
                        :vehicleType => "#{car_user_info.che_xing}-预期#{car_user_info.price}",
                    })
      else
        para.merge!({
                        :tokenKey => '6642FD7E-544F-4228-AC93-224E1EF98A9A',
                        :tokenValue => '7036536a-5a3a-4ab2-aa32-f53f0162f440',
                        :vehicleType => "#{car_user_info.che_xing}",
                        :identifyCode => '',
                        :mobileValidate => '',
                        :id => '',
                        :yuyueId => ''
                    })
      end

      response = RestClient.post url, para
      # pp response.body
      response_json = JSON.parse response.body
      if response_json["result"]
        car_user_info.upload_status = 'success'
        car_user_info.bookid = response_json["bookingId"]
        car_user_info.shibaiyuanyin = ""
      else
        if response_json["message"].match /Mobile\sexist:/
          car_user_info.upload_status = 'yicunzai'
          car_user_info.shibaiyuanyin = ""
        else
          car_user_info.upload_status = 'shibai'
          car_user_info.shibaiyuanyin = "#{response_json["message"]}--#{response_json["message_code"]}"
        end
      end
      car_user_info.save!
    end
  end


  #UserSystem::CarUserInfo.update_che168_detail2
  def self.run_men run_list = true

    if run_list
      begin
        Che168.get_car_user_list
      rescue Exception => e
        pp e
      end
    end
    pp '.........che168列表跑完'


    begin
      Che168.update_detail
    rescue Exception => e
      pp e
    end
    pp '.........che168明细更新完成'


    if run_list
      begin
        TaoChe.get_car_user_list
      rescue Exception => e
        pp e
      end
    end
    pp '.........淘车列表跑完'


    begin
      TaoChe.update_detail
    rescue Exception => e
      pp e
    end
    pp '.........淘车明细更新完成'

    begin
      # UploadTianTian.upload_tt
    rescue Exception => e
      pp e
    end


    begin
      UserSystem::CarUserInfo.upload_to_haoche
    rescue Exception => e
      pp e
    end


    begin
      UserSystem::CarUserInfo.upload_to_haoche
    rescue Exception => e
      pp e
    end


    begin
      UserSystem::CarUserInfo.send_email
      pp Time.now.chinese_format
    rescue Exception => e
      pp e
    end

    # begin
    #   UserSystem::CarUserInfo.update_all_brand
    #     pp '更新品牌结束'
    # rescue Exception => e
    #   pp e
    # end
    #   sleep 60*4
    # end
  end


  #获取20个城市的代码及名称
  # UserSystem::CarUserInfo.get_city_code_name
  def self.get_city_code_name
    provinces = {"440000" => "广东", "370000" => "山东", "330000" => "浙江", "320000" => "江苏", "130000" => "河北", "410000" => "河南", "110000" => "北京", "210000" => "辽宁", "310000" => "上海", "500000" => "重庆", "350000" => "福建", "450000" => "广西", "520000" => "贵州", "620000" => "甘肃", "460000" => "海南", "420000" => "湖北", "430000" => "湖南", "230000" => "黑龙江", "360000" => "江西", "220000" => "吉林", "150000" => "内蒙古", "640000" => "宁夏", "630000" => "青海", "610000" => "陕西", "510000" => "四川", "140000" => "山西", "120000" => "天津", "650000" => "新疆", "540000" => "西藏", "530000" => "云南", "34000" => "安徽"}
    city_hash = {}
    provinces.each_pair do |key, v|
      city_content = RestClient.get("http://m.che168.com/Handler/GetArea.ashx?pid=#{key}")
      pp 'xxx'
      city_content = JSON.parse city_content.body

      city_content["item"].each do |city|
        areaid, areaname = city["id"], city["value"]

        if ::UserSystem::CarUserInfo::ALL_CITY.values.include? areaname
          city_hash[areaid] = areaname
        end
      end
    end
  end


  # 获取需要发送邮件的车主信息
  def self.need_send_mail_car_user_infos
    car_user_infos = self.where(email_status: 0)
    cities = ::UserSystem::CarUserInfo::ALL_CITY.values
    result_car_users = []
    car_user_infos.each do |car_user_info|
      # 只从这20个城市中发
      unless cities.include? car_user_info.city_chinese
        car_user_info.update_attributes email_status: 2
        next
      end
      # 车龄大于等于10年，这个则不发邮件，将改车主信息置为不发邮件状态
      if Time.now.year - (car_user_info.che_ling.to_i rescue 0) >= 10
        car_user_info.update_attributes email_status: 2
        next
      end

      # 车龄大于等于10年，这个则不发邮件，将改车主信息置为不发邮件状态
      if car_user_info.phone.blank?
        car_user_info.update_attributes email_status: 2
        next
      end

      # car_user_info.update_attributes email_status: 1
      result_car_users << car_user_info
    end
    result_car_users
  end

  # 生成每小时xls
  def self.generate_xls_of_car_user_info car_user_infos
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    in_center = Spreadsheet::Format.new horizontal_align: :center, vertical_align: :center, border: :thin
    center_gray = Spreadsheet::Format.new horizontal_align: :center, vertical_align: :center, border: :thin, color: :gray
    sheet1 = book.create_worksheet name: '车主信息数据'
    ['姓名', '电话', '车型', '车龄', '价格', '城市', '备注', '里程', '发布时间', '保存时间', '数据来源', '导入状态', '渠道'].each_with_index do |content, i|
      sheet1.row(0)[i] = content
    end
    current_row = 1
    car_user_infos.each do |car_user_info|
      upload_zhuangtai = case car_user_info.upload_status
                           when 'success'
                             '成功'
                           when 'yicunzai'
                             if car_user_info.bookid.blank?
                               '已存在'
                             else
                               '成功'
                             end
                           when 'shibai'
                             "失败--#{car_user_info.shibaiyuanyin}"
                           else
                             '不导入'
                         end

      [car_user_info.name, car_user_info.phone, car_user_info.che_xing, ("#{(Time.now.year-car_user_info.che_ling.to_i) rescue ''}年"), car_user_info.price, car_user_info.city_chinese, car_user_info.note, "#{car_user_info.milage}万公里", car_user_info.fabushijian, (car_user_info.created_at.chinese_format rescue ''), car_user_info.site_name, upload_zhuangtai, car_user_info.channel].each_with_index do |content, i|
        sheet1.row(current_row)[i] = content
      end
      current_row += 1
    end
    dir = Rails.root.join('public', 'downloads')
    Dir.mkdir dir unless Dir.exist? dir
    file_path = File.join(dir, "#{Time.now.strftime("%Y%m%dT%H%M%S")}车主信息数据.xls")
    book.write file_path
    file_path
  end

  #每日发送四城市表格
  def self.generate_xls_of_four_city
    car_user_infos = ::UserSystem::CarUserInfo.where("created_at > ? and created_at < ?",
                                                     Time.parse("#{Time.now.yesterday.chinese_format_day} 20:00:00"),
                                                     Time.parse("#{Time.now.chinese_format_day} 20:00:00"))
    car_user_infos = car_user_infos.where(city_chinese: ::UserSystem::CarUserInfo::SI_CHENGSHI)

    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    in_center = Spreadsheet::Format.new horizontal_align: :center, vertical_align: :center, border: :thin
    center_gray = Spreadsheet::Format.new horizontal_align: :center, vertical_align: :center, border: :thin, color: :gray
    sheet1 = book.create_worksheet name: '四城市数据'
    ['姓名', '电话', '车型', '车龄', '价格', '城市', '备注', '里程', '发布时间', '保存时间', '数据来源', '导入状态', '渠道'].each_with_index do |content, i|
      sheet1.row(0)[i] = content
    end
    current_row = 1
    pp 'xxeeeeee'
    pp car_user_infos
    pp "xxxx"
    car_user_infos.each do |car_user_info|
      upload_zhuangtai = case car_user_info.upload_status
                           when 'success'
                             '成功'
                           when 'yicunzai'
                             '已存在'
                           when 'shibai'
                             "失败--#{car_user_info.shibaiyuanyin}"
                           else
                             '不导入'
                         end

      [car_user_info.name, car_user_info.phone, car_user_info.che_xing, ("#{(Time.now.year-car_user_info.che_ling.to_i) rescue ''}年"), car_user_info.price, car_user_info.city_chinese, car_user_info.note, "#{car_user_info.milage}万公里", car_user_info.fabushijian, (car_user_info.created_at.chinese_format rescue ''), car_user_info.site_name, upload_zhuangtai, car_user_info.channel].each_with_index do |content, i|
        sheet1.row(current_row)[i] = content
      end
      current_row += 1
    end
    dir = Rails.root.join('public', 'downloads')
    Dir.mkdir dir unless Dir.exist? dir
    file_path = File.join(dir, "#{Time.now.strftime("%Y%m%dT%H%M%S")}-2四城市车主信息数据.xls")
    book.write file_path
    file_path
  end


  def self.update_all_brand
   cuis = UserSystem::CarUserInfo.where("id > #{UserSystem::CarUserInfo::CURRENT_ID} and brand is  null and phone is not null")
   cuis.each_with_index  do |cui, i|
      cui.update_brand
      pp "完成 #{i}/#{cuis.length}"
    end
  end

  def update_brand
    return unless self.brand.blank?
    UserSystem::CarBrand.all.each do |brand|
      if self.che_xing.match Regexp.new(brand.name)
        self.brand = brand.name
        self.save!
        break
      end
    end

    return unless self.brand.blank?

    UserSystem::CarType.all.each do |t|
      if self.che_xing.match Regexp.new(t.name)
          self.brand = t.car_brand.name
          self.save!
          break
      end
    end
  end


  #H6 数据
  def self.generate_xls_of_hv_h6
    car_user_infos = ::UserSystem::CarUserInfo.where("created_at > ? and created_at < ? and che_xing like '%H6%'",
                                                     Time.parse("#{Time.now.yesterday.chinese_format_day} 20:00:00"),
                                                     Time.parse("#{Time.now.chinese_format_day} 20:00:00"))
    if car_user_infos.blank?
      return nil, nil
    end

    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    in_center = Spreadsheet::Format.new horizontal_align: :center, vertical_align: :center, border: :thin
    center_gray = Spreadsheet::Format.new horizontal_align: :center, vertical_align: :center, border: :thin, color: :gray
    sheet1 = book.create_worksheet name: '四城市数据'
    ['姓名', '电话', '车型', '车龄', '价格', '城市', '备注', '里程', '发布时间', '保存时间', '数据来源'].each_with_index do |content, i|
      sheet1.row(0)[i] = content
    end
    current_row = 1
    car_user_infos.each do |car_user_info|
      [car_user_info.name, car_user_info.phone, car_user_info.che_xing, ("#{(Time.now.year-car_user_info.che_ling.to_i) rescue ''}年"), car_user_info.price, car_user_info.city_chinese, car_user_info.note, "#{car_user_info.milage}万公里", car_user_info.fabushijian, (car_user_info.created_at.chinese_format rescue ''), car_user_info.site_name].each_with_index do |content, i|
        sheet1.row(current_row)[i] = content
      end
      current_row += 1
    end
    dir = Rails.root.join('public', 'downloads')
    Dir.mkdir dir unless Dir.exist? dir
    file_path = File.join(dir, "#{Time.now.strftime("%Y%m%dT%H%M%S")}-H6数据.xls")
    book.write file_path
    return file_path, car_user_infos
  end

end
__END__

获取省份列表
    profince_content = `curl 'http://m.che168.com/selectarea.aspx?brandpinyin=&seriespinyin=&specid=&price=1_10&carageid=5&milage=0&carsource=1&store=6&level=0&currentareaid=440100&market=00&key=&backurl=#areaG'`
    profince_content = Nokogiri::HTML(profince_content)
    citys = {}
    profince_content.css(".widget .w-main .w-sift-area a").each do |sheng|
      pp sheng.attributes
      pp sheng

        citys[(sheng.attributes["data-pid"].value rescue '')] = sheng.text.strip



    end
    pp citys


"http://m.che168.com/handler/getcarlist.ashx?num=200&pageindex=1&brandid=0&seriesid=0&specid=0&price=1_10&carageid=5&milage=0&carsource=1&store=6&levelid=0&key=&areaid=#{areaid}&browsetype=0&market=00&browserType=0

  广州，深圳，宁波，东莞，唐山，厦门，上海，西安，重庆，杭州，天津，苏州，成都，福州，长沙，北京，南京，温州，哈尔滨，石家庄，合肥，郑州，武汉，太原，沈阳，无锡，大连，济南，佛山，青岛
