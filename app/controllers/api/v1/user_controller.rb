module API
  module V1
    class UserController < ApplicationController
      def show
        if current_user.blank?
          render json: { error: "User not found" }, status: :not_found
          return
        end
      end
    end
  end
end
