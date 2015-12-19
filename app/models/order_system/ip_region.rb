class OrderSystem::IpRegion < ActiveRecord::Base

  # {:address=>"CN|上海|上海|None|CHINANET|0|0", :province=>"上海市", :city=>"上海市"}
  # 通过IP获得城市名，先从数据库查，查到即返回，查不到就从接口获得，获得后要保存到数据库，然后返回城市名
  # 数据库和接口都查不到，就默认返回上海
  def self.get_city_name ip
    begin
      ip_region = ::OrderSystem::IpRegion.find_by_ip(ip)
      return ip_region.city_name unless ip_region.blank?
      hash = EricTools.get_city_name_from_ip ak: 'HS8ViRxQT0xMu8d3uARISMif', :ip => ip
      unless hash.blank?
        self.transaction do
          ip_region = self.new ip: ip, city_name: hash[:city]
          ip_region.save!
        end
        return hash[:city]
      end
      "上海"
    rescue
      '上海'
    end

  end

end