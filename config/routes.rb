Rails.application.routes.draw do

  namespace :wx do
    namespace :sale do
      resources :market, only: [] do
        collection do
          get :salesman_performance
        end
      end
    end
  end

  namespace :cms do

    namespace :sale do
      resources :market, only: [] do
        collection do
          get :salesman_performance
        end
      end
    end

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

    namespace :sys do
      resources :system_configs
    end
  end

  resources :welcome do
    collection do
      get :share_ewm
      get :agent_ewm
    end
  end

  get '/cms', to: 'cms/employee_validate/functions#login'
  get '', to: 'welcome#index'

  mount ::EricWeixin::Engine, at: "eric_weixin"

end
