module API
  module V1
    module User
      class FollowingsController < ApplicationController
        include Pagy::Backend

        def index
          @pagy, @followings = Rails.cache.fetch("user_#{current_user.id}_following", expires_in: 30.minutes) do
            following = UserRepository.following(current_user)
            pagy(following)
          end
        end
      end
    end
  end
end
