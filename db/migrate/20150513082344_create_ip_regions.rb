class CreateIpRegions < ActiveRecord::Migration
  def change
    create_table :ip_regions do |t|
      t.string :ip
      t.string :city_name

      t.timestamps
    end
  end
end
