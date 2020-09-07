class Api::V1::SubscriptionController < ApplicationController
  before_action :authorize_access_request!

  def show
    return render json: Error.not_found, status: :not_found if subscription?
    render json: SubscriptionSerializer.new(Subscription.find(params[:id]))
  end

  def create
    return render json: Error.missing_params, status: :bad_request if missing_params?

    render json: SubscriptionSerializer.new(Subscription.create(subscription_params)), status: :created
  end

  def update
    render json: SubscriptionSerializer.new(Subscription.update(params[:id], subscription_params))
  end

  def destroy
    subscription = Subscription.find(params[:id])
    render json: SubscriptionSerializer.new(subscription.delete)
  end

  private

  def subscription_params
    params.permit(:delivery_day, :subscription_type, :user_id)
  end

  def missing_params?
    params[:subscription_type].blank? || params[:delivery_day].blank?
  end

  def subscription?
    Subscription.where(id: params[:id]).blank?
  end
end