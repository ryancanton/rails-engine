class Api::V1::MerchantController < ApplicationController
  def index
    render json: MerchantsSerializer.new(Merchant.find(Item.find(params[:item_id]).merchant_id))
  end
end