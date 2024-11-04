class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
end
