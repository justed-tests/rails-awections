# not so bad
class PlaceBid
  attr_reader :status

  def initialize(options)
    @value = options[:value].to_f
    @user = options[:user]
    @auction = options[:auction]
  end

  def execute
    if @auction.ended? && @auction.top_bid.user == @user
      @status = :won
      return false
    end
    bid = @auction.bids.build value: @value, user: @user
    return false if @value <= @auction.current_bid
    if bid.save
      true
    else
      false
    end
  end
end
