# bid the auction
class BidsController < ApplicationController
  require 'place_bid.rb'
  def create
    service = PlaceBid.new(bid_params)
    path = product_path(params[:product_id])

    if service.execute
      redirect_to path, notice: 'success'
    else
      redirect_to path, alert: 'error'
    end
  end

  private

  def bid_params
    auction = Auction.find(params[:auction_id])
    params.require(:bid)
          .permit(:value)
          .merge(user: current_user, auction: auction)
  end
end
