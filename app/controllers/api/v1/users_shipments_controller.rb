class Api::V1::UsersShipmentsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    render json: ShipmentSerializer.new(user.subscription.shipments)
  end

  def show
    render json: ShipmentSerializer.new(Shipment.find(params[:id]))
  end
end