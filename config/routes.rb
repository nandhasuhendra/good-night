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
          get :followers, to: "user/followers#index"
          get :followings, to: "user/followings#index"
          get "followings/sleep_histories", to: "user/following_sleep_histories#index" # Only followed by user can see the sleep histories

          post :clock_in, to: "user/sleep_records#create"
          patch :clock_out, to: "user/sleep_records#update"

          get :sleep_histories, to: "user/sleep_histories#index"
        end
      end

      resources :users, only: %i[index show] do
        member do
          post :follow, to: "users/follows#create"
          delete :unfollow, to: "users/follows#destroy"
          get :sleep_histories, to: "users/sleep_histories#index"
        end
      end
    end
  end
end
