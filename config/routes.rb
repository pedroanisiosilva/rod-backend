Rails.application.routes.draw do
  get 'static_page/about'
  get 'static_page/help'
  get 'static_page/home'
  get 'week_status/index' => 'week_status#index'
  get "week_status/:belt" => "week_status#index", :constraints => {:belt => /.*/}


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

end
