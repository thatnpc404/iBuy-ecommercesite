class AdminsController < ApplicationController
  before_action :admin_authorize
  def index
    @orders = Order.order(created_at: :desc).page(params[:page]).per(10)
  end

  def all_products
    @products=Product.search("*", page: params[:page], per_page: 8)
  end

  private

  def admin_authorize
    unless current_user&.admin?
      redirect_to root_path
    end
  end
end
