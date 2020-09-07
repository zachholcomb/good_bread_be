class Api::V1::Admin::ItemsController < Api::V1::Admin::BaseController
  before_action :authorize_access_request!, :require_admin
  
  def create
    return render json: Error.missing_params, status: :bad_request if missing_params?

    render json: ItemSerializer.new(Item.create(item_params)), status: :created
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
end