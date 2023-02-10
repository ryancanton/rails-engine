class Api::V1::SearchController < ApplicationController
  def find
    if params_valid?(params)
      merchant = Merchant.find_by_name(params[:name])
      if merchant == nil
        render(status: 400, json: { "errors": { } })
      else
        render json: MerchantsSerializer.new(merchant)
      end
      
    else
      render(status: 400)
    end
  end

  def find_all
    if params_valid?(params)
      search_method = determine_search_method(params)
      items = Item.search_all(params, search_method)
      render json: ItemsSerializer.new(items)
    else
      render(status: 400, json: { "errors": { } })
    end
  end
end