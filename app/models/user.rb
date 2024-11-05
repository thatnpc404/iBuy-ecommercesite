class User < ApplicationRecord
    has_many :orders
    has_many :products, foreign_key: "seller_id", dependent: :destroy
    has_many :addresses, foreign_key: "user_id", dependent: :destroy
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable
    has_one :cart, dependent: :destroy

    after_create :create_cart_for_user, if: -> { role == "user" }
    private
    def create_cart_for_user
        Cart.create!(user: self)
    end

    enum role: { admin: 0, customer: 1, seller: 2 }

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :phone_number, presence: true
    validates :role, presence: true
end
