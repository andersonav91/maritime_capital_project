class TradesController < ApplicationController
  def index
    @trades = Trade.where(params[:filters]).page(params[:page]).per(25)
  end
end
