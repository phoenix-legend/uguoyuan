class SystemConfig < ActiveRecord::Base
  validates :k, :presence => true

  def self.get_value k
    configs = SystemConfig.where k: k
    BusinessException.raise "系统配置 system config 中不存在 #{k}" if configs.blank?
    configs.first.v
  end
end
