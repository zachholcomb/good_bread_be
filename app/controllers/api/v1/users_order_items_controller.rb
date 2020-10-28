class Api::V1::UsersOrderItemsController < ApplicationController
  before_action :authorize_access_request!

  def index
    render json: OrderItemSerializer.new(Order.find(params[:order_id]).order_items, include: [:item])
  end
end