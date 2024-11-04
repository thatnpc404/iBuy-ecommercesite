class AdminsController < ApplicationController
  authorize_resource class: false

  def index
    @orders = Order.order(created_at: :desc).page(params[:page]).per(10)
  end

  def all_products
    @products=Product.search("*", page: params[:page], per_page: 8)
  end

end
