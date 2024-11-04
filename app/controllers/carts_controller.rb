class CartsController < ApplicationController
  authorize_resource class: false

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

end
