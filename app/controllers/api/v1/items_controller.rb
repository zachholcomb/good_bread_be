class Api::V1::ItemsController < ApplicationController
  def create
    return render json: Error.missing_params, status: :bad_request if missing_params?

    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def index
    render json: ItemSerializer.new(Item.all)
  end
  
  def show
    return render json: Error.not_found, status: :not_found if item?

    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item.delete)
  end

  private

  def item_params
    params.permit(:name, :price)
  end

  def missing_params?
    params[:name].blank? || params[:price].blank?
  end

  def item?
    Item.where(id: params[:id]).empty?
  end
end