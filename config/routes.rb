Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations, :sessions]

  as :user do
      get "/sign_up" => "devise/registrations#new", :as => :new_user_registration
      post "/sign_up" => "devise/registrations#create", :as => :user_registration
      get "/login" => "devise/sessions#new", :as => :new_user_session
      post "/login" => "devise/sessions#create", :as => :user_session
      delete "/logout" => "devise/sessions#destroy", :as => :destroy_user_session
  end


  # devise_for :users, controllers: {:registrations => "registrations"}
  get 'static_page/about'
  get 'static_page/help'
  get 'static_page/home'
  get 'week_status/index', to: 'week_status#index'
  get 'week_status/:week_number/:belt', to: 'week_status#index'
  get 'week_status/:week_number', to: 'week_status#index'
  get '/users/:id/stats/:year/:target/:w_id', to: 'user_stats#index'

  resources :runs
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'runs#index'

  shallow do
      resources :users, :except => [:destroy] do
           resources :runs
      end
  end

  #api
  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      shallow do
          resources :users, :except => [:destroy] do
               resources :runs
          end
      end
      get '/runs/rank/:period/:qtd', to: 'rank#index', :defaults => {:qtd => 1}, as: :rank
      devise_scope :user do
        post "/sessions" => "sessions#create", :as => :session
        delete "/sessions/destroy" => "sessions#destroy", :as => :session_destroy
        post "/password" => "passwords#create", :as => :passwords
      end
    end
  end
end
