class InternetUserInfo < ActiveRecord::Migration
  def change
    create_table :internet_user_infos do |t|
      t.string :name
      t.string :phone
      t.string :city
      t.string :category
      t.string :list_url
      t.string :detail_url
      t.string :number_of_this_page
      t.string :title
      t.timestamps
    end
  end
end
