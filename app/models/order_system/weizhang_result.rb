class OrderSystem::WeizhangResult < ActiveRecord::Base

  #查询时需要根据车牌号、手机号、车架号、发动机号进行查询。
  def self.weizhang_query options
    result = nil
    OrderSystem::WeizhangResult.transaction do
      weizhang_product = ::OrderSystem::Product.find_by_server_name 'weizhang'
      BusinessException.raise '违章服务不存在' if weizhang_product.blank?
      options[:product_id] = weizhang_product.id
      user_info = ::UserSystem::UserInfo.create_user_info options

      #记录查询日志
      weizhang_log = ::OrderSystem::WeizhangLog.new phone: user_info.phone,
                                                    engine_no: user_info.engine_no,
                                                    vin_no: user_info.vin_no,
                                                    car_number: user_info.car_number

      #查询缓存
      last_result = user_info.weizhang_results.order(created_at: :desc).first
      #48小时以内，同一用户只查询一次
      if last_result && (Time.now - last_result.created_at < 2*24*3600)
        weizhang_log.query_types = 'db'
        weizhang_log.save!
        return user_info.weizhang_results
      end

      weizhang_log.query_types = 'interface'
      url = "http://www.wzcx123.com/biz/yuanyuan.php?vehicle=#{CGI::escape(user_info.car_number)}&type=02&VIN=#{user_info.vin_no}&EIN=#{user_info.engine_no}"
      pp url
      response = RestClient.get url
      weizhang_log.contents = response.body
      pp
      weizhang_log.save!
      result = MultiXml.parse(response.body).deep_symbolize_keys[:result]
      pp result
      if !result[:status].blank? && result[:status].to_i == 0
        OrderSystem::WeizhangResult.create_result user_info.car_number, user_info.id, result
        return user_info.weizhang_results
      end
    end
    error_message = if result[:status].blank?
                      '未进行查询或输入信息有误'
                    else
                      case result[:status].to_i
                        when 1
                          '恭喜你，你现在没有违章信息。|right'
                        when 2
                          '车辆信息错误，请检查。'
                        else
                          '交管局服务器错误，请稍后再试。'
                      end
                    end

    BusinessException.raise error_message
  end


  #可以正常查询时，正常保存。
  #如果数据库中有，但返回结果中没有，说明已经被处理掉了。
  def self.create_result car_number, user_id, result_hash
    OrderSystem::WeizhangResult.where(car_number: car_number).update_all(status: 1)
    result_hash[:ticket].each do |t|
      shijian = t[:when]
      didian = t[:where]
      result = OrderSystem::WeizhangResult.where(car_number: car_number, when: shijian, where: didian).first
      if result.blank?
        result = OrderSystem::WeizhangResult.new province: t[:province],
                                                 city: t[:city],
                                                 district: t[:district],
                                                 when: t[:when],
                                                 where: t[:where],
                                                 why: t[:why],
                                                 code: t[:code],
                                                 fines: t[:fines],
                                                 points: t[:points],
                                                 user_info_id: user_id,
                                                 car_number: car_number
      end
      result.status = 0
      result.save!
    end
  end
end