class Api::V1::UsersController < ApplicationController
  def show
    render json: UserSerializer.new(User.find(params[:id]))
  end

  def update
    render json: UserSerializer.new(User.update(params[:id], user_params))
  end

  def destroy
    user = User.find(params[:id])
    render json: UserSerializer.new(user.delete)
  end

  private

  def user_params
    params.permit(:name, :email, :address, :password)
  end
end
