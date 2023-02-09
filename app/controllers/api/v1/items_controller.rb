class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id] && Merchant.find(params[:merchant_id])
      items = Item.where('items.merchant_id = ?', params[:merchant_id])
    else
      items = Item.all
    end
    render json: ItemsSerializer.new(items)
  end
  
  def show
    item = Item.find(params[:id])
    render json: ItemsSerializer.new(item)
  end

  def create
    new_item = Item.create(item_params)
    render(status: 201, json: ItemsSerializer.new(new_item))
  end 

  def update
    if params[:merchant_id] && !Merchant.find(params[:merchant_id])
      render_not_found_response
    end
    item = Item.update(params[:id].to_i, item_params)
    render(status: 202, json: ItemsSerializer.new(item))
  end

  def destroy
    item = Item.find(params[:id])
    item.delete_solo_invoices
    render json: ItemsSerializer.new(item.destroy)
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end