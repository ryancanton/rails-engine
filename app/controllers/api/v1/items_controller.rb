class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemsSerializer.new(Item.all)
  end
  
  def show
    render json: ItemsSerializer.new(Item.find(params[:id]))
  end

  def create
    new_item = Item.create(item_params)
    render json: ItemsSerializer.new(new_item)
  end 

  def update
    item = Item.update(params[:id], item_params)
    render json: ItemsSerializer.new(item)
  end

  def destroy
    render json: ItemsSerializer.new(Item.destroy(params[:id]))
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end