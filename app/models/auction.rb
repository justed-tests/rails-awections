# in action
class Auction < ApplicationRecord
  belongs_to :product
  has_many :bids

  validates :value, presence: true
  validates :value, numericality: true

  def top_bid
    bids.order(value: :desc).first
  end

  def current_bid
    top_bid ? top_bid.value : value
  end

  def ended?
    Time.now > ends_at
  end
end
