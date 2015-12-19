require "spreadsheet"
class UserSystem::YiwaixianUserInfo < ActiveRecord::Base
  def self.create_yiwaixian_user_info options
    ui = ::UserSystem::YiwaixianUserInfo.new options
    ui.save!
    ui
  end
end