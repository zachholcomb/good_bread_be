class Api::V1::UsersShipmentsController < ApplicationController
  before_action :authorize_access_request!
  
  def index
    render json: ShipmentSerializer.new(current_user.subscription.shipments)
  end

  def show
    render json: ShipmentSerializer.new(current_user.subscription
                                        .shipments
                                        .find(params[:id]))
  end
end