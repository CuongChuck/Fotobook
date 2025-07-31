require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  root "photos#index"
  get "/albums", to: "albums#index"

  devise_for :users, path: '', path_names: {
      sign_in: '/login', sign_out: '/logout',
      password: 'secret', registration: '/signup'
  }
  devise_scope :user do
    put '/signup/edit', to: 'users/registrations#update'
    patch '/signup/edit', to: 'users/registrations#update'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  get '/photos/feeds', to: 'photos#index', as: :user_root
  get '/albums/feeds', to: 'albums#index'
  get '/photos/discover', to: 'photos#index'
  get '/albums/discover', to: 'albums#index'
  get '/photos', to: 'photos#index', as: :admin_root
  resources :users, only: [:index, :edit, :update, :destroy] do
    resources :photos, except: [:show, :index]
    resources :albums, except: [:show, :index] do
      resources :photos, only: [:destroy]
    end
  end
  scope '/users/:user_id' do
    get '/photos', to: 'users#show'
    get '/albums', to: 'users#show'
    get '/followings', to: 'users#show'
    get '/followers', to: 'users#show'
  end
  post '/follow/:id', to: 'interaction#follow'
  delete '/follow/:id', to: 'interaction#unfollow'
  delete '/unfollow/:id', to: 'interaction#unfollow_profile'
  post '/like/album/:id', to: 'interaction#like_album'
  delete '/like/album/:id', to: 'interaction#unlike_album'
  post '/like/photo/:id', to: 'interaction#like_photo'
  delete '/like/photo/:id', to: 'interaction#unlike_photo'
end
