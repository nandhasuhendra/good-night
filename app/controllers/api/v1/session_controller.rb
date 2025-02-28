module API
  module V1
    class SessionController < ApplicationController
      skip_before_action :authenticate_token, only: :create

      def create
        user = User.find_by(email: params[:email])
        if !user&.authenticate(params[:password])
          render json: { error: I18n.t("api.error_messages.invalid_email_or_password") }, status: :unauthorized
          return
        end

        render json: { token: JsonWebToken.encode(user_id: user.id) }
      end
    end
  end
end
