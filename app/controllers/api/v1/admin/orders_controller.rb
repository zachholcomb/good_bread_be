class Api::V1::Admin::OrdersController < Api::V1::Admin::BaseController
  before_action :authorize_access_request!, :require_admin  

  def index
    render json: AdminOrderSerializer.new(Order.all)
  end

  def show
    render json: AdminOrderSerializer.new(Order.find(params[:id]))
  end

  def update
    render json: AdminOrderSerializer.new(Order.update(params[:id], order_params))
  end

  private

  def order_params
    params.permit(:status, :delivery_date)
  end
end