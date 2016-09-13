require 'test_helper'
require 'place_bid'

# test place bid
class PlaceBidTest < MiniTest::Test
  def test_it_places_a_bid
    user = User.create! email: 'some@one.org', password: 'password'
    another_user = User.create! email: 'some@another.org', password: 'password'
    product = Product.create! name: 'product', user: user
    auction = Auction.create! value: 10, product: product

    service = PlaceBid.new value: 11, user: another_user, auction: auction

    service.execute

    assert_equal 11, auction.current_bid
  end
end
