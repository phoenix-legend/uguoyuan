class UserSystem::CarUserInfoSendEmail < ActiveRecord::Base

  def self.had_send_email_in_current_hour?
    return false if self.all.blank?
    last_send_time = self.all.order(:id).last.created_at
    Time.now - last_send_time < 60*60
  end

  def self.create_car_user_info_send_email options
    options = self.get_arguments_options options, [:receiver, :cc, :attachment_name, :record_number]
    self.transaction do
      cue = self.new options
      cue.save!
      # cue.reload
      cue
    end
  end
end
