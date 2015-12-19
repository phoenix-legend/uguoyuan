Rails.application.routes.draw do
  namespace :cms do
    namespace :personal do
      resources :organizations do
        member do
          get :set_roles
          post :commit_roles
        end
      end
    end
    resources :employees do
      collection do
        get :set_role
        post :set_role
      end
    end
    resources :roles do
      collection do
        get :set_functions
        post :set_functions
      end
    end
    namespace :employee_validate do
      resource :functions do
        collection do
          get :index
          get :welcome
          get :menu
          get :login
          post :login
          get :logout
          get :list
          post :update2
          get :not_teacher
          get :modify_password
          post :modify_password
        end
      end
    end


    namespace :order_system do
      resources :products
      resources :templates
      resources :comments
    end


    namespace :user_system do
      resources :user_infos do
        collection do
          get :export_users_xls
          post :export_users_xls
        end
      end

    end

    namespace :sys do
      resources :system_configs
    end
  end

  namespace :dwz do
    namespace :haoche_stat do
      resources :promation do
        collection do
          get :join_us
          get :product_list
          get :topics
        end
      end

    end

  end

  namespace :wz do
    namespace :order_system do
      resources :products do
        collection do
          get :new_appointment
          post :create_appointment
          get :appointment_success
          get :appointment_success2
          get :compare_price
          post :search_price
          get :search_price
          get :display_price
          get :get_city_name
          post :get_city_name
          get :jiankangxian
          post :create_jiankangxian
          get :new_index
        end
      end
    end

    namespace :weizhang do
      resources :chaxun do
        collection do
          get :no_weizhang
          post :result
        end
      end
    end
  end

  namespace :api, :defaults => {:format => 'json'} do
    namespace :v1 do
      resource :update_user_infos do
        collection do
          get :update_user_by_xiecheyangche
          post :update_user_by_xiecheyangche
          post :update_car_user_info
          get :yiwaixian
          post :yiwaixian
          get :get_need_update_tt_info
          post :update_tt_info
        end
      end
    end
  end


  root to: "wz/order_system/products#new_index"
  get '/cms', to: 'cms/employee_validate/functions#login'
  get '/dwz', to: 'dwz/haoche_stat/promation#index'

  get '/i/:template_name/:qudao_name', to: "wz/order_system/products#index"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  #root to: "cms/employees#index"
end
