Rails.application.routes.draw do
  # devise_for :users, controllers: {:registrations => "registrations"}
  get 'static_page/about'
  get 'static_page/help'
  get 'static_page/home'
  get 'week_status/index', to: 'week_status#index'
  get 'week_status/:week_number/:belt', to: 'week_status#index'
  get 'week_status/:week_number', to: 'week_status#index'

  get '/users/:id/stats/:year/:target/:w_id', to: 'user_stats#index'

  # as :user do
  #   get "/register", to: "registrations#new", as: "register"
  # end

  resources :runs
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#index'

  shallow do
     resources :users do
          resources :runs
     end
 end

  devise_for :users, controllers: {:registrations => "registrations"}

end
