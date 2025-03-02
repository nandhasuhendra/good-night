module API
  module V1
    module User
      class FollowingSleepHistoriesController < ApplicationController
        include Pagy::Backend

        def index
          following_user_ids = current_user.following.pluck(:id)
          @sleep_histories = SleepRecords::WeeklyHistoriesService.call(current_user.id, following_user_ids, params[:week_start])
          @pagy, @sleep_histories = pagy(@sleep_histories)
        end
      end
    end
  end
end
