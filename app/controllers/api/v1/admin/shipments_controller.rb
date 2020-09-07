class Api::V1::Admin::ShipmentsController < Api::V1::Admin::BaseController
  before_action :authorize_access_request!, :require_admin

  def create
    return render json: Error.missing_params, status: :bad_request if missing_params?
    render json: ShipmentSerializer.new(Shipment.create(shipment_params)), status: :created
  end

  def index
    render json: ShipmentSerializer.new(Shipment.all)
  end
  
  def show
    render json: ShipmentSerializer.new(Shipment.find(params[:id]))
  end

  def update
    render json: ShipmentSerializer.new(Shipment.update(params[:id], shipment_params))
  end

  def destroy
    shipment = Shipment.find(params[:id])
    render json: ShipmentSerializer.new(shipment.delete)
  end

  private 

  def shipment_params
    params.permit(:status, :delivery_date, :subscription_id)
  end

  def missing_params?
    params[:subscription_id].blank? || params[:status].blank? ||
    params[:status].blank? 
  end
end