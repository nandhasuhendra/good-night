module API
  module V1
    module Users
      class FollowsController < ApplicationController
        def create
          user = ::User.find(params[:id])
          result = ::Friends::FollowService.call(current_user, user)
          if result.failure?
            render json: { errors: result.result }, status: :unprocessable_entity
            return
          end

          render json: { data: result.result }, status: :created
        end

        def destroy
          user = ::User.find(params[:id])
          result = ::Friends::UnfollowService.call(current_user, user)
          if result.failure?
            render json: { errors: result.result }, status: :unprocessable_entity
            return
          end

          head :no_content
        end
      end
    end
  end
end
