class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantsSerializer.new(Merchant.all)
  end
  
  def show
    render json: MerchantsSerializer.new(Merchant.find(params[:id]))
  end
end