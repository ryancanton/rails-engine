class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_repsonse

  def render_not_found_response
    render json: { error: ActiveRecord::RecordNotFound }, status: :not_found
  end

  def render_invalid_record_repsonse
    render json: { error: ActiveRecord::RecordInvalid }, status: 422
  end

  def params_valid?(params)
    return false unless params[:name] || params[:min_price] || params[:max_price]
    return false if params[:name] == ''
    return false if (params[:min_price].to_f < 0 || params[:max_price].to_f < 0)
    return false if params[:name] && (params[:min_price] || params[:max_price])
    return false if (params[:min_price] && params[:max_price]) && (params[:min_price].to_f > params[:max_price].to_f)
    return true
  end

  def determine_search_method(params)
    if params[:name]
      return 'name'
    else
      return 'price'
    end
  end
end
