json.array! @user_infos do |user_info|
  json.id user_info.id
  json.name user_info.name
  json.phone user_info.phone
  json.city user_info.city_chinese
  json.che_xing user_info.che_xing
  json.brand user_info.brand
end