class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemsSerializer.new(Item.all)
  end
  
  def show
    render json: ItemsSerializer.new(Item.find(params[:id]))
  end

  def create

  end

  def update

  end

  def destroy

  end
end