# proudcts live here
class Product < ApplicationRecord
  belongs_to :user
  has_many :auctions

  def auctions?
    auctions.any?
  end

  def on_auction?
    !!auction
  end

  def auction
    auctions.last
  end
end
