class CartsController < ApplicationController
  #before_action :user_authorize
  #before_action :set_cart_and_items, only: [ :checkout ]

  def index
    set_cart_and_items
  end

  def checkout
    redirect_to orders_path
  end

  private

  def set_cart_and_items
    @cart = Cart.find_by(user_id: current_user.id)
    @line_items = @cart.line_items.includes(:product) if @cart
  end

  def user_authorize
    unless current_user&.user?
      redirect_to root_path
    end
  end
end
