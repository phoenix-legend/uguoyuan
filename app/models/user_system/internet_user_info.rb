class UserSystem::InternetUserInfo < ActiveRecord::Base


  def self.create_info options
    iui = ::UserSystem::InternetUserInfo.where  phone: options[:phone]
    return unless iui.blank?
    info = ::UserSystem::InternetUserInfo.new options
    info.save!
  end


  def self.get_chinese_cityname
    cities = UserSystem::InternetUserInfo.get_all_city
    hash_cty = {}
    cities.each do |city|
      hash_cty[city[0]] = city[2]
    end
    UserSystem::InternetUserInfo.all.each do |info|
      info.city_name = hash_cty[info.city]
      info.save!
    end

  end


  # UserSystem::InternetUserInfo.focus
  def self.focus
    # citys = ['sh', 'bj', 'sz', 'tj', 'gz', 'cd', 'cq', 'sjz', 'cs', 'hn', 'sanya', 'jn', 'qd', 'wh', 'xa', 'km', 'nj', 'hz', 'qhd', 'hrb', 'sy', 'zz', 'suzhou', 'fs']
    citys = ['bj', 'sz', 'tj', 'gz', 'cd', 'cq', 'sjz', 'cs', 'hn', 'sanya', 'jn', 'qd', 'wh', 'xa', 'km', 'nj', 'hz', 'qhd', 'hrb', 'sy', 'zz', 'suzhou', 'fs']
    # citys = ["sh"]
    citys.each do |city_name|
      host = "#{city_name}.esf.focus.cn/"
      city_url = "#{city_name}.esf.focus.cn/agent/"
      # city_url = "http://sh.esf.focus.cn/agent/"
      content = `curl '#{city_url}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: global_wapandm_cookie=nswiidhghms8p127uf3mqb3r730ibj0104n; global_cookie=0bab37cc-1435648460044-66998e9a; __utmt_t0=1; __utmt_t1=1; __utmt_t2=1; __utma=147393320.1313865077.1435648464.1435761767.1435920774.7; __utmb=147393320.6.10.1435920774; __utmc=147393320; __utmz=147393320.1435648464.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); unique_cookie=U_tur6pl0ia82wx5ce0g35abr7j3vibni5jf0*2' -H 'Connection: keep-alive' --compressed`
      doc = Nokogiri::HTML(content)
      dl = doc.css(".wrap #topFilters .bd dl").first
      dl.css("dd a").each_with_index do |quyu, i|
        next if i == 0
        qu_href = quyu.attributes["href"].value
        qu_url = "#{host}#{qu_href}"

        pp qu_url

        # qu_url = "http://sh.esf.focus.cn/agent/q111"
        shangquan_content = `curl '#{qu_url}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: global_wapandm_cookie=nswiidhghms8p127uf3mqb3r730ibj0104n; global_cookie=0bab37cc-1435648460044-66998e9a; __utmt_t0=1; __utmt_t1=1; __utmt_t2=1; __utma=147393320.1313865077.1435648464.1435761767.1435920774.7; __utmb=147393320.6.10.1435920774; __utmc=147393320; __utmz=147393320.1435648464.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); unique_cookie=U_tur6pl0ia82wx5ce0g35abr7j3vibni5jf0*2' -H 'Connection: keep-alive' --compressed`
        shangquan_doc = Nokogiri::HTML(shangquan_content)
        sq_dl = shangquan_doc.css(".wrap #topFilters .bd dl").first
        sq_dl.css("dd .subarea a").each_with_index do |shangquan_url,i|
          next if i == 0
          u = shangquan_url.attributes["href"].value
          UserSystem::InternetUserInfo.focus_fanye city_name, "#{host}#{u}"
        end

      end
    end
  end

  def self.focus_fanye city, url
    # city = 'sh'
    # url = "sh.esf.focus.cn/agent/q110a30067"
    old_content = '1'
    (1..1000).each do |yema|
      yema_url = "#{url}p#{yema}"


      exists_url = ::UserSystem::InternetUserInfo.where list_url: yema_url
      unless exists_url.blank?
        pp "#{yema_url}已经存在，跳过"
        next
      end

      pp "正在抓取页面：#{yema_url}"

      content = `curl '#{yema_url}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: global_wapandm_cookie=nswiidhghms8p127uf3mqb3r730ibj0104n; global_cookie=0bab37cc-1435648460044-66998e9a; __utmt_t0=1; __utmt_t1=1; __utmt_t2=1; __utma=147393320.1313865077.1435648464.1435761767.1435920774.7; __utmb=147393320.6.10.1435920774; __utmc=147393320; __utmz=147393320.1435648464.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); unique_cookie=U_tur6pl0ia82wx5ce0g35abr7j3vibni5jf0*2' -H 'Connection: keep-alive' --compressed`
      doc = Nokogiri::HTML(content)
      items = doc.css("#listItem .items")
      pp "本页有数据#{items.length}条"




      new_content = ""
      items.each do |item|
        name = item.css(".items_m div h2 a").children.first.text rescue ''
        phone = item.css(".items_r em").children.first.text rescue ''
        new_content = new_content + phone
        ::UserSystem::InternetUserInfo.create_info name: name,
                                                   phone: phone,
                                                   city: city,
                                                   category: '二手房',
                                                   list_url: yema_url,
                                                   detail_url: '经纪人页面',
                                                   number_of_this_page: yema,
                                                   wangzhan_name: 'focus.cn'
      end
      if new_content == old_content
        pp '跟上一页相同，跳过'
        break;
      end
      old_content = new_content
    end



  end






  def self.get_all_city
    except_city =[] # ['bj', 'sh', 'gz', 'sz', 'tj', 'cd', 'cq', 'wuhan', 'suzhou', 'hz', 'nanjing',
    # 'jn', 'zz', 'sjz', 'xian', 'wuxi', 'qd', 'nc', 'dg', 'dl', 'km', 'changchun']

    url = 'http://esf.changchun.fang.com/newsecond/esfcities.aspx'
    content = `curl '#{url}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: global_wapandm_cookie=nswiidhghms8p127uf3mqb3r730ibj0104n; global_cookie=0bab37cc-1435648460044-66998e9a; __utmt_t0=1; __utmt_t1=1; __utmt_t2=1; __utma=147393320.1313865077.1435648464.1435761767.1435920774.7; __utmb=147393320.6.10.1435920774; __utmc=147393320; __utmz=147393320.1435648464.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); unique_cookie=U_tur6pl0ia82wx5ce0g35abr7j3vibni5jf0*2' -H 'Connection: keep-alive' --compressed`
    ec = Encoding::Converter.new("gb18030", "UTF-8")
    content = ec.convert content
    doc = Nokogiri::HTML(content)
    city_array = []
    doc.css("#c01 ul li a").each_with_index do |city, i|
      begin
        wangzhan = city.attributes["href"].value
        city_regular = /http\:\/\/esf\.(.*)\.fang\.com/.match(wangzhan)
        city_name = city_regular[1]
        city_array << [city_name, '', city.children.first.text]
      rescue Exception => e
      end
    end
    city_array = city_array.delete_if { |city| except_city.include?(city[0]) }
    city_array.each do |c|
      c[1] = '/agenthome/'
    end
    city_array

  end

  # UserSystem::InternetUserInfo.need_run
  def self.need_run array=nil
    a = [
        # ['tj', '/agenthome-a041/-i31-j310/', '天津'],
        # ['cd', '/agenthome-a0132/-i31-j310/', '成都'],
        # ['cq', '/agenthome-a058/-i31-j310/', '重庆'],
        # ['wuhan', '/agenthome-a0494/-i31-j310/', '武汉'],
        # ['suzhou', '/agenthome-a0277/-i31-j310/', '苏州'],
        # ['hz', '/agenthome-a0151/-i31-j310/', '杭州'],
        # ['nanjing', '/agenthome-a0265/-i31-j310/', '南京'],
        # ['jn', '/agenthome-a0386/-i31-j310/', '济南'],
        # ['zz', '/agenthome-a0362/-i31-j310/', '郑州'],
        # ['sjz', '/agenthome-a0357-b05163/-i31-j310/', '石家庄'],
        # ['xian', '/agenthome-a0478-b04113/-i31-j310/', '西安'],
        # ['wuxi', '/agenthome-a0767-b03826/-i31-j310/', '无锡'],
        # ['qd', '/agenthome-a0389-b012143/-i31-j310/', '青岛'],
        # ['nc', '/agenthome-a0504-b05790/-i31-j310/', '南昌'],
        # ['dg', '/agenthome-a099/-i31-j310/', '东莞'],
        # ['dl', '/agenthome-a0256-b04364/-i31-j310/', '大连'],
        # ['km', '/agenthome-a01086-b07255/-i31-j310/', '昆明']
        # ['changchun', '/agenthome/', '长春']
    ]

    a = UserSystem::InternetUserInfo.get_all_city
    yijingpaoguo = []
    unless array.blank?
      a = array
    end
    a.each do |city_info|
      yijingpaoguo << city_info
      city = city_info[0]
      agent = city_info[1]
      next if /\A[a-fA-F]/.match(city)
      init_host = "http://esf.#{city}.fang.com"
      init_url = "#{init_host}#{agent}"
      UserSystem::InternetUserInfo.fenpianqu_common init_host, init_url, city
      pp "#{city_info[2]}已经跑完"*100
    end
    yijingpaoguo
  end

  def self.fenpianqu_common init_host, init_url, city
    content = `curl '#{init_url}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: global_wapandm_cookie=nswiidhghms8p127uf3mqb3r730ibj0104n; global_cookie=0bab37cc-1435648460044-66998e9a; __utmt_t0=1; __utmt_t1=1; __utmt_t2=1; __utma=147393320.1313865077.1435648464.1435761767.1435920774.7; __utmb=147393320.6.10.1435920774; __utmc=147393320; __utmz=147393320.1435648464.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); unique_cookie=U_tur6pl0ia82wx5ce0g35abr7j3vibni5jf0*2' -H 'Connection: keep-alive' --compressed`
    ec = Encoding::Converter.new("gb18030", "UTF-8")
    content = ec.convert content
    doc = Nokogiri::HTML(content)
    doc.css("#list_38 .qxName a").each_with_index do |qu, i|
      next if i == 0
      qu_url = "#{init_host}#{qu.attributes["href"].value}"
      qu_content = `curl '#{qu_url}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: global_wapandm_cookie=nswiidhghms8p127uf3mqb3r730ibj0104n; global_cookie=0bab37cc-1435648460044-66998e9a; __utmt_t0=1; __utmt_t1=1; __utmt_t2=1; __utma=147393320.1313865077.1435648464.1435761767.1435920774.7; __utmb=147393320.6.10.1435920774; __utmc=147393320; __utmz=147393320.1435648464.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); unique_cookie=U_tur6pl0ia82wx5ce0g35abr7j3vibni5jf0*2' -H 'Connection: keep-alive' --compressed`
      qu_content = ec.convert qu_content
      qu_doc = Nokogiri::HTML(qu_content)
      qu_doc.css("#shangQuancontain a").each_with_index { |shangquan, i|
        next if i == 0
        shangquan_url = "#{init_host}/#{shangquan.attributes["href"].value}"
        begin_url = shangquan_url.gsub('-i31-j310/', '')

        # pudong = /agenthome-a025/
        # unless (pudong.match begin_url).blank?
        #   puts '浦东已过'
        #   next
        # end


        UserSystem::InternetUserInfo.jingjiren_ershoufang_fangcom 1, 700, city, begin_url

      }
    end
  end

  def self.jingjiren_ershoufang_fangcom begin_page, end_page, city, begin_url
    category = '二手房'
    a = 0
    b = 0
    old_content = '1'
    (begin_page..end_page).each do |i|
      url = "#{begin_url}-i3#{i}-j310/"
      exists_url = ::UserSystem::InternetUserInfo.where list_url: url
      unless exists_url.blank?
        pp "#{url}已经存在，跳过"
        next
      end
      pp "正在抓取#{url}"
      a = a+1
      content = `curl '#{url}' -connect-timeout 10  -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://esf.fang.com/agenthome/-i31-j310/' -H 'Cookie: global_wapandm_cookie=nswiidhghms8p127uf3mqb3r730ibj0104n; global_cookie=0bab37cc-1435648460044-66998e9a; unique_wapandm_cookie=U_nswiidhghms8p127uf3mqb3r730ibj0104n*19; unique_cookie=U_0bab37cc-1435648460044-66998e9a*9; __utma=147393320.1313865077.1435648464.1435673927.1435761767.6; __utmb=147393320.34.10.1435761767; __utmc=147393320; __utmz=147393320.1435648464.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed`
      ec = Encoding::Converter.new("gb18030", "UTF-8")
      content = ec.convert content
      doc = Nokogiri::HTML(content)
      dts = doc.css(".agent_pic .house  dt")

      if dts.length > 0
        b = b+1
        pp "当前是第 #{i} 页， 获取到名单继续"
      else
        pp "当前是第 #{i} 页， 没获取任何名单，可能可结束了,再跑 #{10-(a-b)}页"
      end
      if b-a > 10
        pp "当前是第 #{i} 页"
        pp '后面没有页码了，到此结束。'
        break;
      end
      if old_content.to_s == dts.to_s
        pp "当前是第 #{i} 页"
        pp '开始重复前一页面，结束'
        break;
      end
      old_content = dts.to_s
      doc.css(".agent_pic .house  dt").each do |dt|
        name = dt.css(".housetitle a").text.strip
        dian = dt.css(".black")[0].css("span").text.strip
        phone = dt.css("p strong").text.strip
        ::UserSystem::InternetUserInfo.create_info name: "#{name}-#{dian}",
                                                   phone: phone,
                                                   city: city,
                                                   category: category,
                                                   list_url: url,
                                                   detail_url: '经纪人页面',
                                                   number_of_this_page: i,
                                                   wangzhan_name: 'fang.com'
      end
    end
  end


  # UserSystem::InternetUserInfo.bj_ershoufang_fangcom
  def self.bj_ershoufang_fangcom
    url = 'http://m.fang.com/esf/?purpose=%D7%A1%D5%AC&city=%B1%B1%BE%A9&keywordtype=qz&gettype=android&correct=true&pagesizeslipt=5&c=esf&a=ajaxGetList&city=bj&r=0.19393627950921655&page='
    UserSystem::InternetUserInfo.common_fangcom 83, 1000000, url, 'bj', '二手房'
  end

  def self.common_fangcom first_page, last_page, url, city, category
    (first_page..last_page).each do |page_number|

      list_url = "#{url}#{page_number}"
      list = `curl '#{list_url}' -connect-timeout 10 -H 'Cookie: global_wapandm_cookie=nswiidhghms8p127uf3mqb3r730ibj0104n; global_cookie=0bab37cc-1435648460044-66998e9a; JSESSIONID=aaaX67rMAS2Qqdrukvd5u; cityHistory=%u5317%u4EAC%2Cbj; unique_cookie=U_0bab37cc-1435648460044-66998e9a*1; __utmt_t0=1; __utmt_t1=1; mencity=bj; firstlocation=0; __utmmobile=0xd62c3f59d73760d8; __utma=147393320.1313865077.1435648464.1435667166.1435669750.4; __utmb=147393320.10.10.1435669750; __utmc=147393320; __utmz=147393320.1435648464.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); mencity=bj; unique_wapandm_cookie=U_nswiidhghms8p127uf3mqb3r730ibj0104n*16' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'User-Agent: Mozilla/5.0 (Linux; U; Android 4.1; en-us; GT-N7100 Build/JRO03C) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30' -H 'Accept: */*' -H 'Referer: http://m.fang.com/esf/bj/' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --compressed `

      doc = Nokogiri::HTML(list)
      link_nodes = doc.css('li a')
      link_nodes.each do |link_node|
        link = link_node["href"]
        if link.blank?
          puts '链接为空，跳过'
          next
        end

        detail_link = (link.split('?')[0] rescue link)
        exists_detail = ::UserSystem::InternetUserInfo.where detail_url: detail_link
        unless exists_detail.blank?
          pp "#{pp link} 已经查询过，跳过"
          next
        end

        content = `curl -A "Mozilla/5.0 (Linux; U; Android 4.1; en-us; GT-N7100 Build/JRO03C) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30" -L #{link}`
        ec = Encoding::Converter.new("gbk", "UTF-8")
        doc = Nokogiri::HTML(content)
        doc.css('.xqZygw p')
        name = doc.css('.xqZygw p span')[0].text rescue ''
        phone = doc.css('.xqZygw p span')[2].text rescue ''
        name = ec.convert(name)


        ::UserSystem::InternetUserInfo.create_info name: name,
                                                   phone: phone,
                                                   city: city,
                                                   category: category,
                                                   list_url: list_url,
                                                   detail_url: (link.split('?')[0] rescue link),
                                                   number_of_this_page: page_number,
                                                   wangzhan_name: 'fang.com'
      end
    end
  end


  # UserSystem::InternetUserInfo 1, 197, http://m.58.com/sh/zufang/, '二手房', 'bj'
  def self.common_58 first_page, last_page, url, category, city
    (first_page..last_page).each do |page_number|
      list_url = "#{url}pn#{page_number}/"
      list = `curl -A "Mozilla/5.0 (Linux; U; Android 4.1; en-us; GT-N7100 Build/JRO03C) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30" -L #{list_url} `
      doc = Nokogiri::HTML(list)
      link_nodes = doc.css('body div .list-info li a')
      link_nodes.each do |link_node|
        link = link_node.attributes["href"].value
        pp link
        if link.blank?
          puts '链接为空'
          next
        end
        detail_link = (link.split('?')[0] rescue link)
        exists_detail = ::UserSystem::InternetUserInfo.where detail_url: detail_link
        unless exists_detail.blank?
          pp "#{pp link} 已经查询过，跳过"
          next
        end


        detail_page = `curl -A "Mozilla/5.0 (Linux; U; Android 4.1; en-us; GT-N7100 Build/JRO03C) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30" -L #{link} `

        doc = Nokogiri::HTML(detail_page)
        name = doc.css(".landlord .llname").children.first.text rescue ''
        require 'pp'
        pp name

        phone = doc.css(".landlord .llnumber").children.first.text rescue ''
        pp phone


        ::UserSystem::InternetUserInfo.create_info name: name,
                                                   phone: phone,
                                                   city: city,
                                                   category: category,
                                                   list_url: list_url,
                                                   detail_url: (link.split('?')[0] rescue link),
                                                   number_of_this_page: page_number,
                                                   title: title

      end
    end
  end

  #上海租房
  # ::UserSystem::InternetUserInfo.get_sh_zufang_info
  def self.get_sh_zufang_info
    UserSystem::InternetUserInfo.common_58 1, 295, 'http://m.58.com/sh/zufang/', '租房', 'sh'
  end

  #上海二手车
  # ::UserSystem::InternetUserInfo.get_sh_ershouche_info
  def self.get_sh_ershouche_info
    UserSystem::InternetUserInfo.common_58 1, 140, 'http://m.58.com/sh/ershouche/', '二手车', 'sh'
  end

  #上海二手房
  # ::UserSystem::InternetUserInfo.get_sh_ershoufang_info
  def self.get_sh_ershoufang_info
    UserSystem::InternetUserInfo.common_58 1, 270, 'http://m.58.com/sh/ershoufang/', '二手房', 'sh'
  end


  #北京二手房
  # ::UserSystem::InternetUserInfo.get_bj_ershoufang_info
  #UserSystem::InternetUserInfo.common_58 63, 270, 'http://m.58.com/bj/ershoufang/', '二手房', 'bj'
  def self.get_bj_ershoufang_info
    UserSystem::InternetUserInfo.common_58 1, 270, 'http://m.58.com/bj/ershoufang/', '二手房', 'bj'
  end


  #北京租房
  # ::UserSystem::InternetUserInfo.get_bj_zufang_info
  # UserSystem::InternetUserInfo.common_58 1, 300, 'http://m.58.com/bj/zufang/', '租房', 'bj'
  def self.get_bj_zufang_info
    UserSystem::InternetUserInfo.common_58 1, 300, 'http://m.58.com/bj/zufang/', '租房', 'bj'
  end


  #广州二手房
  # ::UserSystem::InternetUserInfo.get_gz_ershoufang_info
  def self.get_gz_ershoufang_info
    UserSystem::InternetUserInfo.common_58 1, 270, 'http://m.58.com/gz/ershoufang/', '二手房', 'gz'
  end


  #广州租房
  # ::UserSystem::InternetUserInfo.get_gz_zufang_info
  def self.get_gz_zufang_info
    UserSystem::InternetUserInfo.common_58 1, 300, 'http://m.58.com/gz/zufang/', '租房', 'gz'
  end


  #深圳二手房
  # ::UserSystem::InternetUserInfo.get_sz_ershoufang_info

  def self.get_sz_ershoufang_info
    UserSystem::InternetUserInfo.common_58 1, 270, 'http://m.58.com/sz/ershoufang/', '二手房', 'sz'
  end


  #深圳租房
  # ::UserSystem::InternetUserInfo.get_sz_zufang_info
  def self.get_sz_zufang_info
    UserSystem::InternetUserInfo.common_58 1, 300, 'http://m.58.com/sz/zufang/', '租房', 'sz'
  end


end
__END__