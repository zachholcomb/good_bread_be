class Api::V1::SubscriptionController < ApplicationController
  before_action :authorize_access_request!

  def index
    return render json: Error.not_found, status: :not_found if subscription?

    render json: { subscription: SubscriptionSerializer.new(
      current_user.subscription
      ),
      shipment: ShipmentSerializer.new(
        current_user.subscription.next_shipment
      )
    }
  end

  def create
    return render json: Error.missing_params, status: :bad_request if missing_params?

    subscription = SubscriptionCreator.create_subscription(current_user, subscription_params)
    render json: SubscriptionSerializer.new(subscription), status: :created
  end

  def update
    render json: SubscriptionSerializer.new(
      Subscription.update(params[:id], subscription_params), include: [:shipments]
    )
  end

  def destroy
    render json: SubscriptionSerializer.new(current_user.subscription.delete)
  end

  private

  def subscription_params
    params.permit(:delivery_day, :subscription_type, :user_id, :amount, :allergies, :flavors?)
  end

  def missing_params?
    params[:amount].blank? || params[:flavors?].blank?
  end

  def subscription?
    current_user.subscription.nil?
  end
end