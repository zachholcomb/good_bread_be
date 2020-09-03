class Api::V1::UsersController < ApplicationController
  def index
    render json: UserSerializer.new(User.all)
  end

  def show
    render json: UserSerializer.new(User.find(params[:id]))
  end

  def create
    return render json: Error.missing_params, status: :bad_request if missing_params?
    return render json: Error.mismatched_passwords, status: :bad_request unless passwords_match?
    return render json: Error.same_email, status: :bad_request if email_in_use?

    render json: UserSerializer.new(User.create(user_params)), status: :created
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

  def missing_params?
    params[:email].blank? || params[:name].blank? || 
    params[:password_confirmation].blank? || params[:address].blank? ||
    params[:password].blank?
  end

  def passwords_match?
    params[:password] == params[:password_confirmation]
  end

  def email_in_use?
    User.find_by(email: params[:email])
  end
end
