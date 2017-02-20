class SystemConfig < ActiveRecord::Base
  validates :k, :presence => true
  require 'pp'

  def self.get_value k
    configs = SystemConfig.where k: k
    BusinessException.raise "系统配置 system config 中不存在 #{k}" if configs.blank?
    configs.first.v
  end

  def self.v k, default=''
    sc = SystemConfig.where(k: k).first
    if sc.blank?
      sc = SystemConfig.find_or_create_by!(k: k, v: default)
    end
    return sc.v
  end

end
