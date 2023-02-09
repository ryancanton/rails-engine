class Api::V1::MerchantController < ApplicationController
  def index
    merchant = Merchant.find(Item.find(params[:item_id]).merchant_id)
    if merchant
      render json: MerchantsSerializer.new(merchant)
    else
      render_not_found_response
    end
  end
end