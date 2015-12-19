class UserSystem::CarType < ActiveRecord::Base

  belongs_to :car_brand, :class_name => 'UserSystem::CarBrand'

end
__END__
