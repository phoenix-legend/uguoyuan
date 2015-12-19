class AddAdsWordToProducts < ActiveRecord::Migration
  def change
    add_column :products, :adds_words, :string, :limit=> 300
  end
end
