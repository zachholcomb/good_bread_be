class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end
  
  def show
    return render json: Error.not_found, status: :not_found if item?

    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  private
  
  def item?
    Item.where(id: params[:id]).empty?
  end
end