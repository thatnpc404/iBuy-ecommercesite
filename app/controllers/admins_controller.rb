class AdminsController < ApplicationController
  before_action :admin_authorize
  def index
    Order.refresh_all_order_statuses
    @orders=Order.all.order(created_at: :desc)
  end

  private

  def admin_authorize
    unless current_user&.admin?
      redirect_to root_path
    end
  end
end
