class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_repsonse

  def render_not_found_response
    render json: { error: ActiveRecord::RecordNotFound }, status: :not_found
  end

  def render_invalid_record_repsonse
    render json: { error: ActiveRecord::RecordInvalid }, status: 422
  end
end
