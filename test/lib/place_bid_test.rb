require 'test_helper'
require 'place_bid'

# test place bid
class PlaceBidTest < MiniTest::Test
  attr_reader :user, :another_user, :product, :auction

  def setup
    @user = User.create! email: 'some@one.org', password: 'password'
    @another_user = User.create! email: 'some@another.org', password: 'password'
    @product = Product.create! name: 'product', user: user
    @auction = Auction.create!(
      value: 10,
      product: product,
      ends_at: Time.now + 24.hours
    )
  end

  def test_it_places_a_bid
    service = PlaceBid.new value: 11, user: another_user, auction: auction
    service.execute
    assert_equal 11, auction.current_bid
  end

  def test_fails_to_bid_under_current_value
    service = PlaceBid.new value: 7, user: another_user, auction: auction
    refute service.execute, 'bid should not placed'
  end

  def test_notifies_if_auction_ended
    service = PlaceBid.new value: 11, user: user, auction: auction
    service.execute
    another_service = PlaceBid.new value: 888, user: user, auction: auction

    Timecop.travel(Time.now + 25.hours)
    another_service.execute

    assert_equal :won, another_service.status
  end
end
