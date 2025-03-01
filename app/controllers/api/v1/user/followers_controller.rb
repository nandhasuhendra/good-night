module API
  module V1
    module User
      class FollowersController < ApplicationController
        include Pagy::Backend

        def index
          @pagy, @followers = Rails.cache.fetch("user_#{current_user.id}_followers", expires_in: 30.minutes) do
            followers = UserRepository.followers(current_user)
            pagy(followers)
          end
        end
      end
    end
  end
end
