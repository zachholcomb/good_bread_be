class Api::V1::SubscriptionsController < ApplicationController
  def index
    render json: SubscriptionSerializer.new(Subscription.all)
  end

  def show
    return render json: Error.not_found, status: :not_found if subscription?
    render json: SubscriptionSerializer.new(Subscription.find(params[:id]))
  end

  private

  def subscription?
    Subscription.where(id: params[:id]).blank?
  end
end