class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  
  def current_user
    @current_user ||= User.find(payload['user_id'])
  end

  def current_admin?
    current_user && @current_user.admin?
  end

  def not_authorized
    render json: Error.unauthorized, status: :unauthorized
  end
end
