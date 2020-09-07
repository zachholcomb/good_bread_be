class Api::V1::Admin::SubscriptionsController < Api::V1::Admin::BaseController
  before_action :authorize_access_request!, :require_admin

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