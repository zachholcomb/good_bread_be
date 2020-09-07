class Api::V1::Admin::BaseController < ApplicationController
  before_action :require_admin

  def require_admin
    render json: { error: "Unauthorized" }, status: unauthorized unless current_admin?
  end
end