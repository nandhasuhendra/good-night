class ApplicationController < ActionController::API
  protect_from_forgery with: :null_session

  before_action :ensure_json_request
  before_action :authenticate_token

  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_json_parse_error

  def authenticate_token
    token = request.headers["Authorization"]&.split(" ")&.last
    decoded_token = JsonWebToken.decode(token)

    if !decoded_token
      render json: { error: I18n.t("api.error_messages.invalid_token") }, status: :unauthorized
      return
    end

    @current_user = User.find(decoded_token[:user_id])
  end

  def current_user
    @current_user
  end

  private

  def ensure_json_request
    return if request.format.json?

    render json: { error: I18n.t("api.error_messages.invalid_acceptable_format") }, status: :not_acceptable
  end

  def handle_json_parse_error
    render json: { error: I18n.t("api.error_messages.invalid_json_format") }, status: :bad_request
  end
end
