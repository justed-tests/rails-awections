class Auction < ApplicationRecord
  belongs_to :product

  validates :value, presence: true
  validates :value, numericality: true
end
