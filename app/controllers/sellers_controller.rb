class SellersController < ApplicationController
  authorize_resource class: false  
  def index
    @sellers=User.where(role: "seller")
  end

end
