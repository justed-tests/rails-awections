# bid the auction
class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  validates :value, presence: true
  validates :value, numericality: true
end
