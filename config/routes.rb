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
          scope module: :user do
            get :followings, to: "followings#index"
            get :followers, to: "followers#index"
            post :clock_in, to: "sleep_records#create"
            patch :clock_out, to: "sleep_records#update"
          end
        end
      end

      resources :users, only: %i[index show] do
        member do
          scope module: :users do
            post :follow, to: "follows#create"
            delete :unfollow, to: "follows#destroy"
            post :clock_in, to: "sleep_records#create"
            patch :clock_out, to: "sleep_records#update"
          end
        end
      end
    end
  end
end
