class SellersController < ApplicationController
  #before_action :admin_authorize
  
  def index
    @sellers=User.where(role: "seller")
  end

  private

  def admin_authorize
    if current_user&.admin?
      redirect_to root_path
    end
  end
end
