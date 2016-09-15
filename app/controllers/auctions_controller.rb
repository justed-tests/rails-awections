# lets help auctions to work!
class AuctionsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    auction = product.auctions.build(auction_params)

    if auction.save
      redirect_to product, notice: 'Product was put to auction'
    else
      redirect_to product, alert: 'Something went wrong, review your data'
    end
  end

  private

  def auction_params
    params.require(:auction).permit(:value, :ends_at)
  end
end
