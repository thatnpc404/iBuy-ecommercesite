class LineItem < ApplicationRecord
  belongs_to :cart, optional: true
  belongs_to :order, optional: true
  belongs_to :product
  validates :quantity, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :cart_id, presence: false
end
