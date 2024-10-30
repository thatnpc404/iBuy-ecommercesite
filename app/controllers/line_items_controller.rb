class LineItemsController < ApplicationController
  before_action :user_authorize
  def show
  end

  def create
    @cart = Cart.find_by(user_id: current_user.id)
    max_line_items_limit = 5
    new_quantity = line_item_params[:quantity].to_i
    product_id = line_item_params[:product_id]
    product = Product.find(product_id)
    product_quantity = product.stock_quantity
    @line_items = @cart.line_items
    @line_item = @line_items.find_by(product_id: product_id)
    if new_quantity > product_quantity
      flash.now[:alert] = "Requested quantity exceeds available stock!"
      return redirect_back(fallback_location: product_path(product_id))
    end

    if @line_item.nil?
      @line_item = @cart.line_items.build(line_item_params)
      @line_item.quantity = new_quantity
    else
      existing_quantity = @line_item.quantity
      if (existing_quantity + new_quantity) > max_line_items_limit
        flash.now[:alert] = "Cannot exceed the limit of #{max_line_items_limit} items!"
        return redirect_back(fallback_location: product_path(product_id))
      else
        @line_item.quantity = new_quantity+existing_quantity
      end
    end

    unless @line_item.save
      flash.now[:alert] = "Error adding to cart!"
      return redirect_back(fallback_location: product_path(product_id))
    end
    redirect_to product_path(product_id)
  end

  def update
    @line_item = LineItem.find(params[:id])
    @line_item.update(line_item_params)
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    unless @line_item.destroy
      flash[:alert]="Error removing item from cart !"
    end
    redirect_back fallback_location: product_path(@line_item.product_id)
  end

  private

  def line_item_params
    params.require(:line_item).permit(:product_id, :order_id, :cart_id, :quantity, :price, :status)
  end

  def user_authorize
    unless current_user&.user?
      redirect_to root_path
    end
  end
end
