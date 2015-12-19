class UserSystem::CarBrand < ActiveRecord::Base
  require 'rest-client'
  require 'pp'

  # UserSystem=>=>CarBrand.get_brand
  def self.get_brand
    data = [{"id"=>117,"name"=>"AC Schnitzer","bfirstletter" =>"A"},{"id"=>34,"name"=>"阿尔法罗密欧","bfirstletter"=>"A"},{"id"=>35,"name"=>"阿斯顿·马丁","bfirstletter"=>"A"},{"id" =>221,"name"=>"安凯客车","bfirstletter"=>"A"},{"id"=>33,"name"=>"奥迪","bfirstletter"=>"A"},{"id"=>140,"name"=>"巴博斯","bfirstletter"=>"B"},{"id"=>120,"name"=>"宝骏","bfirstletter"=>"B"},{"id"=>15,"name"=>"宝马","bfirstletter" =>"B"},{"id"=>40,"name"=>"保时捷","bfirstletter"=>"B"},{"id"=>27,"name"=>"北京","bfirstletter"=>"B"},{"id"=>203,"name"=>"北汽幻速","bfirstletter"=>"B"},{"id"=>173,"name"=>"北汽绅宝","bfirstletter"=>"B"},{"id"=>143,"name"=>"北汽威旺","bfirstletter"=>"B"},{"id"=>208,"name"=>"北汽新能源","bfirstletter"=>"B"},{"id"=>154,"name"=>"北汽制造","bfirstletter"=>"B"},{"id"=>36,"name"=>"奔驰","bfirstletter"=>"B"},{"id"=>95,"name"=>"奔腾","bfirstletter"=>"B"},{"id"=>14,"name"=>"本田","bfirstletter"=>"B"},{"id"=>75,"name"=>"比亚迪","bfirstletter"=>"B"},{"id"=>13,"name"=>"标致","bfirstletter"=>"B"},{"id"=>38,"name"=>"别克","bfirstletter"=>"B"},{"id"=>39,"name"=>"宾利","bfirstletter"=>"B"},{"id"=>37,"name"=>"布加迪","bfirstletter"=>"B"},{"id"=>79,"name"=>"昌河","bfirstletter"=>"C"},{"id"=>76,"name"=>"长安","bfirstletter"=>"C"},{"id"=>163,"name"=>"长安商用","bfirstletter"=>"C"},{"id"=>77,"name"=>"长城","bfirstletter"=>"C"},{"id"=>196,"name"=>"成功汽车","bfirstletter"=>"C"},{"id"=>169,"name"=>"DS","bfirstletter"=>"D"},{"id"=>92,"name"=>"大发","bfirstletter"=>"D"},{"id"=>1,"name"=>"大众","bfirstletter"=>"D"},{"id"=>41,"name"=>"道奇","bfirstletter"=>"D"},{"id"=>32,"name"=>"东风","bfirstletter"=>"D"},{"id"=>187,"name"=>"东风风度","bfirstletter"=>"D"},{"id"=>113,"name"=>"东风风神","bfirstletter"=>"D"},{"id"=>165,"name"=>"东风风行","bfirstletter"=>"D"},{"id"=>142,"name"=>"东风小康","bfirstletter"=>"D"},{"id"=>81,"name"=>"东南","bfirstletter"=>"D"},{"id"=>42,"name"=>"法拉利","bfirstletter"=>"F"},{"id"=>11,"name"=>"菲亚特","bfirstletter"=>"F"},{"id"=>3,"name"=>"丰田","bfirstletter"=>"F"},{"id"=>141,"name"=>"福迪","bfirstletter"=>"F"},{"id"=>197,"name"=>"福汽启腾","bfirstletter"=>"F"},{"id"=>8,"name"=>"福特","bfirstletter"=>"F"},{"id"=>96,"name"=>"福田","bfirstletter"=>"F"},{"id"=>112,"name"=>"GMC","bfirstletter"=>"G"},{"id"=>152,"name"=>"观致","bfirstletter"=>"G"},{"id"=>116,"name"=>"光冈","bfirstletter"=>"G"},{"id"=>82,"name"=>"广汽传祺","bfirstletter"=>"G"},{"id"=>108,"name"=>"广汽吉奥","bfirstletter"=>"G"},{"id"=>24,"name"=>"哈飞","bfirstletter"=>"H"},{"id"=>181,"name"=>"哈弗","bfirstletter"=>"H"},{"id"=>150,"name"=>"海格","bfirstletter"=>"H"},{"id"=>86,"name"=>"海马","bfirstletter"=>"H"},{"id"=>43,"name"=>"悍马","bfirstletter"=>"H"},{"id"=>164,"name"=>"恒天","bfirstletter"=>"H"},{"id"=>91,"name"=>"红旗","bfirstletter"=>"H"},{"id"=>245,"name"=>"华凯","bfirstletter"=>"H"},{"id"=>237,"name"=>"华利","bfirstletter"=>"H"},{"id"=>85,"name"=>"华普","bfirstletter"=>"H"},{"id"=>220,"name"=>"华颂","bfirstletter"=>"H"},{"id"=>87,"name"=>"华泰","bfirstletter"=>"H"},{"id"=>97,"name"=>"黄海","bfirstletter"=>"H"},{"id"=>46,"name"=>"Jeep","bfirstletter"=>"J"},{"id"=>25,"name"=>"吉利汽车","bfirstletter"=>"J"},{"id"=>84,"name"=>"江淮","bfirstletter"=>"J"},{"id"=>119,"name"=>"江铃","bfirstletter"=>"J"},{"id"=>210,"name"=>"江铃集团轻汽","bfirstletter"=>"J"},{"id"=>44,"name"=>"捷豹","bfirstletter"=>"J"},{"id"=>83,"name"=>"金杯","bfirstletter"=>"J"},{"id"=>145,"name"=>"金龙","bfirstletter"=>"J"},{"id"=>175,"name"=>"金旅","bfirstletter"=>"J"},{"id"=>151,"name"=>"九龙","bfirstletter"=>"J"},{"id"=>109,"name"=>"KTM","bfirstletter"=>"K"},{"id"=>156,"name"=>"卡尔森","bfirstletter"=>"K"},{"id"=>224,"name"=>"卡升","bfirstletter"=>"K"},{"id"=>199,"name"=>"卡威","bfirstletter"=>"K"},{"id"=>101,"name"=>"开瑞","bfirstletter"=>"K"},{"id"=>47,"name"=>"凯迪拉克","bfirstletter"=>"K"},{"id"=>214,"name"=>"凯翼","bfirstletter"=>"K"},{"id"=>219,"name"=>"康迪","bfirstletter"=>"K"},{"id"=>100,"name"=>"科尼赛克","bfirstletter"=>"K"},{"id"=>9,"name"=>"克莱斯勒","bfirstletter"=>"K"},{"id"=>241,"name"=>"LOCAL MOTORS","bfirstletter"=>"L"},{"id"=>48,"name"=>"兰博基尼","bfirstletter"=>"L"},{"id"=>118,"name"=>"劳伦士","bfirstletter"=>"L"},{"id"=>54,"name"=>"劳斯莱斯","bfirstletter"=>"L"},{"id"=>215,"name"=>"雷丁","bfirstletter"=>"L"},{"id"=>52,"name"=>"雷克萨斯","bfirstletter"=>"L"},{"id"=>10,"name"=>"雷诺","bfirstletter"=>"L"},{"id"=>124,"name"=>"理念","bfirstletter"=>"L"},{"id"=>80,"name"=>"力帆","bfirstletter"=>"L"},{"id"=>89,"name"=>"莲花汽车","bfirstletter"=>"L"},{"id"=>78,"name"=>"猎豹汽车","bfirstletter"=>"L"},{"id"=>51,"name"=>"林肯","bfirstletter"=>"L"},{"id"=>53,"name"=>"铃木","bfirstletter"=>"L"},{"id"=>204,"name"=>"陆地方舟","bfirstletter"=>"L"},{"id"=>88,"name"=>"陆风","bfirstletter"=>"L"},{"id"=>49,"name"=>"路虎","bfirstletter"=>"L"},{"id"=>50,"name"=>"路特斯","bfirstletter"=>"L"},{"id"=>20,"name"=>"MG","bfirstletter"=>"M"},{"id"=>56,"name"=>"MINI","bfirstletter"=>"M"},{"id"=>58,"name"=>"马自达","bfirstletter"=>"M"},{"id"=>57,"name"=>"玛莎拉蒂","bfirstletter"=>"M"},{"id"=>55,"name"=>"迈巴赫","bfirstletter"=>"M"},{"id"=>129,"name"=>"迈凯伦","bfirstletter"=>"M"},{"id"=>168,"name"=>"摩根","bfirstletter"=>"M"},{"id"=>130,"name"=>"纳智捷","bfirstletter"=>"N"},{"id"=>213,"name"=>"南京金龙","bfirstletter"=>"N"},{"id"=>60,"name"=>"讴歌","bfirstletter"=>"O"},{"id"=>59,"name"=>"欧宝","bfirstletter"=>"O"},{"id"=>146,"name"=>"欧朗","bfirstletter"=>"O"},{"id"=>61,"name"=>"帕加尼","bfirstletter"=>"P"},{"id"=>26,"name"=>"奇瑞","bfirstletter"=>"Q"},{"id"=>122,"name"=>"启辰","bfirstletter"=>"Q"},{"id"=>62,"name"=>"起亚","bfirstletter"=>"Q"},{"id"=>235,"name"=>"前途","bfirstletter"=>"Q"},{"id"=>63,"name"=>"日产","bfirstletter"=>"R"},{"id"=>19,"name"=>"荣威","bfirstletter"=>"R"},{"id"=>174,"name"=>"如虎","bfirstletter"=>"R"},{"id"=>103,"name"=>"瑞麒","bfirstletter"=>"R"},{"id"=>45,"name"=>"smart","bfirstletter"=>"S"},{"id"=>64,"name"=>"萨博","bfirstletter"=>"S"},{"id"=>205,"name"=>"赛麟","bfirstletter"=>"S"},{"id"=>68,"name"=>"三菱","bfirstletter"=>"S"},{"id"=>149,"name"=>"陕汽通家","bfirstletter"=>"S"},{"id"=>155,"name"=>"上汽大通","bfirstletter"=>"S"},{"id"=>66,"name"=>"世爵","bfirstletter"=>"S"},{"id"=>90,"name"=>"双环","bfirstletter"=>"S"},{"id"=>69,"name"=>"双龙","bfirstletter"=>"S"},{"id"=>162,"name"=>"思铭","bfirstletter"=>"S"},{"id"=>65,"name"=>"斯巴鲁","bfirstletter"=>"S"},{"id"=>238,"name"=>"斯达泰克","bfirstletter"=>"S"},{"id"=>67,"name"=>"斯柯达","bfirstletter"=>"S"},{"id"=>202,"name"=>"泰卡特","bfirstletter"=>"T"},{"id"=>133,"name"=>"特斯拉","bfirstletter"=>"T"},{"id"=>161,"name"=>"腾势","bfirstletter"=>"T"},{"id"=>102,"name"=>"威麟","bfirstletter"=>"W"},{"id"=>99,"name"=>"威兹曼","bfirstletter"=>"W"},{"id"=>192,"name"=>"潍柴英致","bfirstletter"=>"W"},{"id"=>70,"name"=>"沃尔沃","bfirstletter"=>"W"},{"id"=>114,"name"=>"五菱汽车","bfirstletter"=>"W"},{"id"=>167,"name"=>"五十铃","bfirstletter"=>"W"},{"id"=>98,"name"=>"西雅特","bfirstletter"=>"X"},{"id"=>12,"name"=>"现代","bfirstletter"=>"X"},{"id"=>185,"name"=>"新凯","bfirstletter"=>"X"},{"id"=>71,"name"=>"雪佛兰","bfirstletter"=>"X"},{"id"=>72,"name"=>"雪铁龙","bfirstletter"=>"X"},{"id"=>111,"name"=>"野马汽车","bfirstletter"=>"Y"},{"id"=>110,"name"=>"一汽","bfirstletter"=>"Y"},{"id"=>144,"name"=>"依维柯","bfirstletter"=>"Y"},{"id"=>73,"name"=>"英菲尼迪","bfirstletter"=>"Y"},{"id"=>93,"name"=>"永源","bfirstletter"=>"Y"},{"id"=>206,"name"=>"知豆","bfirstletter"=>"Z"},{"id"=>22,"name"=>"中华","bfirstletter"=>"Z"},{"id"=>74,"name"=>"中兴","bfirstletter"=>"Z"},{"id"=>94,"name"=>"众泰","bfirstletter"=>"Z"}]
    data.each do |d|
      b = UserSystem::CarBrand.new :name => d["name"],
                               :key_str => d["id"]
      b.save!
    end
  end


  def self.get_car_type
    UserSystem::CarBrand.all.each do |cb|
      response = RestClient.get "http://www.autohome.com.cn/ashx/AjaxIndexCarFind.ashx?type=3&value=#{cb.key_str}"
      ec = Encoding::Converter.new("gbk", "UTF-8")
      response = ec.convert(response.body)
      response = JSON.parse response
      response["result"]["factoryitems"].each do |factory|
        factory["seriesitems"].each do |series|
          ct = UserSystem::CarType.new :name => series["name"],
                                       :car_brand_id => cb.id

          ct.save!
        end
      end
    end
  end


end
__END__

获取省份列表
    profince_content = `curl 'http=>//m.che168.com/selectarea.aspx?brandpinyin=&seriespinyin=&specid=&price=1_10&carageid=5&milage=0&carsource=1&store=6&level=0&currentareaid=440100&market=00&key=&backurl=#areaG'`
    profince_content = Nokogiri=>=>HTML(profince_content)
    citys = {}
    profince_content.css(".widget .w-main .w-sift-area a").each do |sheng|
      pp sheng.attributes
      pp sheng

        citys[(sheng.attributes["data-pid"].value rescue '')] = sheng.text.strip



    end
    pp citys


"http=>//m.che168.com/handler/getcarlist.ashx?num=200&pageindex=1&brandid=0&seriesid=0&specid=0&price=1_10&carageid=5&milage=0&carsource=1&store=6&levelid=0&key=&areaid=#{areaid}&browsetype=0&market=00&browserType=0

  广州，深圳，宁波，东莞，唐山，厦门，上海，西安，重庆，杭州，天津，苏州，成都，福州，长沙，北京，南京，温州，哈尔滨，石家庄，合肥，郑州，武汉，太原，沈阳，无锡，大连，济南，佛山，青岛
