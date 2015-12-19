class AddTemplateNameToUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :template_name, :string
    add_column :user_infos, :qudao_name, :string
  end
end
