class OrderSystem::CarInsurancePrice < ActiveRecord::Base
  def self.get_price options
    ::OrderSystem::CarInsurancePrice.where(city_name: options[:city], car_price: options[:car_price]).order(insurance_price: :asc)
  end
end