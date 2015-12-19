class CreateCarUserInfoSendEmails < ActiveRecord::Migration
  def change
    create_table :car_user_info_send_emails do |t|
      t.string :receiver
      t.string :cc
      t.string :attachment_name
      t.integer :record_number

      t.timestamps
    end
  end
end
