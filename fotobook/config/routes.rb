Rails.application.routes.draw do
  root "photos#index"
  get "/albums", to: "albums#index"

  devise_for :users, path: '', path_names: {
      sign_in: '/login', sign_out: '/logout',
      password: 'secret', confirmation: 'verification',
      registration: '/signup', edit: 'edit/profile'
    }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  get '/photos/feed', to: 'photos#index', as: :user_root
  get '/albums/feed', to: 'albums#index'
  get '/photos/discover', to: 'photos#index'
  get '/albums/discover', to: 'albums#index'
  get '/photos/manage', to: 'photos#index', as: :admin_root
  get '/albums/manage', to: 'albums#index'
  get '/user/photos', to: 'users#show'
  get '/user/albums', to: 'users#show'
  get '/user/followings', to: 'users#show'
  get '/user/followers', to: 'users#show'
end
