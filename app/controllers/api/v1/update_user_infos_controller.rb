class Api::V1::UpdateUserInfosController < Api::V1::BaseController

  def update_user_by_xiecheyangche
    ::UserSystem::UserInfo.update_user_by_xieche params[:id]
  end

  def yiwaixian
    json = UserSystem::UserInfo.yiwaixianjiekou params
    render :json => json, :layout  => false
  end

  def update_car_user_info
    car_user_info = UserSystem::CarUserInfo.find params[:id]
    user_infos = UserSystem::CarUserInfo.where name: params[:name],
                                               phone: params[:phone]

                                               # che_xing: car_user_info.che_xing,
                                               # che_ling: car_user_info.che_ling,
                                               # city_chinese: car_user_info.city_chinese
    unless user_infos.length > 0
      car_user_info.name = params[:name]
      car_user_info.phone = params[:phone]
      car_user_info.note = params[:note]
      car_user_info.fabushijian = params[:fabushijian]
      car_user_info.price = params[:price]
    end
    car_user_info.need_update = false
    car_user_info.save!
  end



  #获取天天渠道需要提交的数据
  def get_need_update_tt_info
    @user_infos = UploadTianTian.need_upload_tt
  end

  def update_tt_info
    UploadTianTian.update_car_user_info params
  end

end