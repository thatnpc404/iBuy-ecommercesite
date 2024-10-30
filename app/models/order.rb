class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  def self.refresh_all_order_statuses
    Order.find_each do |order|
      if order.line_items.all? { |line_item| line_item.status == "Dispatched" }
        order.update(status: "Confirmed")
      elsif order.line_items.all? { |line_item| line_item.status == "Cancelled" }
        order.update(status: "Cancelled")
      else
        order.update(status: "Partial")
      end
    end
  end
end
