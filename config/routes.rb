require 'sidekiq/web'
SIPTreadmill::Application.routes.draw do
  resources :test_runs do
    member do
      post 'enqueue'
      post 'cancel'
      post 'stop'
      get  'copy'
    end
  end
  resources :targets
  resources :profiles
  resources :scenarios

  resources :users, only: [:index, :show, :edit, :update, :copy]
  resources :users do
    member do
      get 'generate_token'
    end
  end

  post '/home/toggle_admin'

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    delete "logout" => "devise/sessions#destroy", :as => :destroy_user_session
  end

  root to: "home#index"
end
