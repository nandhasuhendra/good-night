module API
  module V1
    module User
      class FollowingSleepHistoriesController < ApplicationController
        include Pagy::Backend

        def index
          result = SleepRecords::WeeklyHistoriesService.call(
            current_user,
            params[:week_start],
            page: params[:page],
            per_page: params[:per_page] || Pagy::DEFAULT[:limit]
          )

          @pagy = result[:pagy]
          @sleep_histories = result[:sleep_histories]
        end
      end
    end
  end
end
