class ApplicationController < ActionController::API
  before_action :ensure_json_request
  before_action :authenticate_token

  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_json_parse_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from StandardError, with: :handle_internal_server_error

  def default_url_options(options={})
    { locale: I18n.locale }
  end

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

  def record_not_found
    render json: { error: I18n.t("api.error_messages.record_not_found") }, status: :not_found
  end

  def handle_internal_server_error(exception)
    Rails.logger.error(exception.message)
    Rails.logger.error(exception.backtrace.join("\n"))

    render json: { error: I18n.t("api.error_messages.internal_server_error") }, status: :internal_server_error
  end
end
