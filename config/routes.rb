Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api, format: :json do
    namespace :v1 do
      post :login, to: "session#create"

      resource :user do
        collection do
          get :followings, to: "user/followings#index"
          get :followers, to: "user/followers#index"
        end
      end

      resources :users, only: %i[index show] do
        member do
          post :follow, to: "users/follows#create", as: :follow
          delete :unfollow, to: "users/follows#destroy", as: :unfollow
        end
      end
    end
  end
end
