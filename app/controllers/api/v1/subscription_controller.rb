class Api::V1::SubscriptionController < ApplicationController
  before_action :authorize_access_request!

  def index
    return render json: Error.not_found, status: :not_found if subscription?

    render json: SubscriptionSerializer.new(current_user.subscription, include: [:shipments])
  end

  def create
    return render json: Error.missing_params, status: :bad_request if missing_params?

    render json: SubscriptionSerializer.new(Subscription.create(subscription_params)), status: :created
  end

  def update
    render json: SubscriptionSerializer.new(Subscription.update(params[:id], subscription_params))
  end

  def destroy
    render json: SubscriptionSerializer.new(current_user.subscription.delete)
  end

  private

  def subscription_params
    params.permit(:delivery_day, :subscription_type, :user_id)
  end

  def missing_params?
    params[:subscription_type].blank? || params[:delivery_day].blank?
  end

  def subscription?
    current_user.subscription.nil?
  end
end