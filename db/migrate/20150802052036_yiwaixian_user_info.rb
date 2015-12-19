class YiwaixianUserInfo < ActiveRecord::Migration
  def change
    create_table :yiwaixian_user_infos do |t|
      t.string :realname
      t.string :gender
      t.string :birth
      t.string :mobile
      t.string :product
      t.string :parentname
      t.string :city
      t.string :idcard
      t.string :carmodel
      t.string :remark
      t.string :answer1
      t.string :answer2
      t.string :answer3
      t.string :policy_no
      t.string :policy_result
      t.string :result_code
      t.timestamps


    end
  end
end
