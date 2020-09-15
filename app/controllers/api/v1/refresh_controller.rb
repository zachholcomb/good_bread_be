class Api::V1::RefreshController < ApplicationController
  before_action :authorize_refresh_by_access_request!

  def create
    session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
    tokens = sessionl.refresh_by_access_allowed do
      raise JWTSessions::Errors::Unauthorized, "Somethings not right here!"
    end
    response.set_cookie(JWTSessions.access_cokie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?)
    render json: { csrf: tokens[:csrf] }
  end
end