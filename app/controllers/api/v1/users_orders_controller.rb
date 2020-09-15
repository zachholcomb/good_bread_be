class Api::V1::UsersOrdersController < ApplicationController
  before_action :authorize_access_request!
  
  def create
    user = User.find(params[:user_id])
    order = user.orders.create(order_params)
    params[:items].each do |item|
      OrderItem.create(order: order, item_id: item.to_i)
    end
    render json: { order: OrderSerializer.new(order), user: UserSerializer.new(user)}, status: :created
  end

  def index
    user = User.find(params[:user_id])
    render json: OrderSerializer.new(user.orders)
  end

  private

  def order_params
    params.permit(:delivery_date, :status)
  end
end