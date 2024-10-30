class Product < ApplicationRecord
  searchkick callbacks: :async
  has_one_attached :img_url

  validates :name, presence: { message: "must be present" }, uniqueness: { message: "must be unique" }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true
  belongs_to :seller, class_name: "User", foreign_key: "seller_id"
  belongs_to :category

  def search_data
    {
      name: name,
      description: description,
      price: price,
      stock_quantity: stock_quantity,
      category_id: category_id,
      seller_id: seller_id
    }
  end
end
