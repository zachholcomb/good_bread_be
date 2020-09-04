class Api::V1::ShipmentsController < ApplicationController
  def create
    render json: ShipmentSerializer.new(Shipment.create(shipment_params)), status: :created
  end

  private 

  def shipment_params
    params.permit(:status, :delivery_date, :subscription_id)
  end
end