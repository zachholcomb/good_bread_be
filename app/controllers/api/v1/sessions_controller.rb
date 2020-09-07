class Api::V1::SessionsController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def new
    user = User.new(user_params)
    if user.save
      tokens = LoginHandler.session(build_payload(user))
      set_response(tokens)
      render json: { csrf: tokens[:csrf], user: UserSerializer.new(user) }, status: :created
    else
      render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end
  
  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      tokens = LoginHandler.session(build_payload(user))
      set_response(tokens)
      render json: { csrf: tokens[:csrf], user: UserSerializer.new(user) }
    else
      not_authorized  
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: :ok
  end

  private

  def user_params
    params.permit(:email, :name, :address, :password, :password_confirmation)
  end

  def build_payload(user)
    { user_id: user.id }
  end

  def set_response(tokens)
    response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
  end
end 