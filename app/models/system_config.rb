class SystemConfig < ActiveRecord::Base
  validates :k, :presence => true
  require 'pp'

  def self.get_value k
    configs = SystemConfig.where k: k
    BusinessException.raise "系统配置 system config 中不存在 #{k}" if configs.blank?
    configs.first.v
  end

  def self.v k, default=''
    v = SystemConfig.find_or_create_by!(k: "订单付款后文案-非首单").v
    if v.blank?
      return default
    else
      v
    end
  end

end
