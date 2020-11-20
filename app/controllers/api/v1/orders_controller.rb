class Api::V1::OrdersController < ApplicationController
  def create
    user = GuestCreator.create(params[:userParams])
    if user.save
      order = user.orders.create(order_params)
      params[:items].each do |(item, quantity)|
        OrderItem.create(order: order, item_id: item.to_i, quantity: quantity[:quantity])
      end
      render json: { order: OrderSerializer.new(order), user: UserSerializer.new(user)}, status: :created
    else
      render json: { error: user.errors.full_messages.join(' ') }, status: :bad_request
    end
  end

  private

  def order_params
    params.permit(:status, :delivery_date)
  end
end