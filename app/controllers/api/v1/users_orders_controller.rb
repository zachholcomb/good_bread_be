class Api::V1::UsersOrdersController < ApplicationController
  before_action :authorize_access_request!
  
  def create
    order = current_user.orders.create(order_params)
    params[:items].each do |(item, quantity)|
        OrderItem.create(order: order, item_id: item.to_i, quantity: quantity[:quantity])
    end
    render json: { order: OrderSerializer.new(order, include: [:items]), user: UserSerializer.new(current_user)}, status: :created
  end

  def index
    render json: OrderSerializer.new(current_user.orders, include: [:items])
  end

  private

  def order_params
    params.permit(:delivery_date, :status)
  end
end