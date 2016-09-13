# not so bad
class PlaceBid
  def initialize(options)
    @value = options[:value]
    @user = options[:user]
    @auction = options[:auction]
  end

  def execute
    bid = @auction.bids.build value: @value, user: @user
    true if bid.save
  end
end
