class Address < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  validates :shipping_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :zip_code, presence: true
end
