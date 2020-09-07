class Api::V1::Admin::UsersController < Api::V1::Admin::BaseController
  before_action :authorize_access_request!, :require_admin
  
  def index
    render json: UserSerializer.new(User.get_users)
  end
end