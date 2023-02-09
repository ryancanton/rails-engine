class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantsSerializer.new(Merchant.all)
  end
  
  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantsSerializer.new(merchant)
  end
end