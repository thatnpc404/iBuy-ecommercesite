class OrdersController < ApplicationController
  before_action :set_order, only: [ :show ]
  before_action :user_authorize, only: [ :order_requests, :approve ]

  def show
    @user=current_user
    @order=Order.find(params[:id])
  end

  def index
    @user=current_user
    @orders = @user.orders.order(created_at: :desc)
  end

  def payment_page
    @address_id=params[:address_id]
    @order=Order.new # Creationg new order instance over here
    render :payment
  end

  def checkout
    @address=Address.new  # because im partially rendering the new page of address
    @cart = Cart.find_by(user_id: current_user.id)
    @line_items = @cart.line_items.includes(:product) if @cart
  end


  def create
    @user=current_user
    @cart=@user.cart
    @line_items = LineItem.where(cart_id: @cart.id)
    @address=Address.find(params[:address_id])
    @order=@user.orders.new(total_price: calculate_total_price, shipping_address: @address.shipping_address, zip_code: @address.zip_code, state: @address.state, city: @address.city, country: @address.country, payment_status: "pending", status: "pending")
    if @order.save
      @line_items.each do |line_item|
        if line_item.persisted?
          line_item.update(order_id: @order.id)
          line_item.product.update(stock_quantity: line_item.product.stock_quantity-line_item.quantity)
        end
      end
      @order=order_refresh(@order)
      @cart.line_items.update_all(cart_id: nil)
      redirect_to orders_path, notice: "Order Placed Successfully !"
    else
        flash.now[:alert] = "Error creating order."
        render :payment
    end
  end

  def order_refresh(order)
      if order.line_items.all? { |line_item| line_item.status == "Dispatched" }
        order.update(status: "Confirmed")
      elsif order.line_items.all? { |line_item| line_item.status == "Cancelled" }
        order.update(status: "Cancelled")
      else
        order.update(status: "Partial")
      end
      order
  end

  def calculate_total_price
    total_price=0
    @line_items.each do |line_item|
      total_price+=line_item.price
    end
    total_price
  end

  def order_requests # this is from the seller side
    @products = Product.where(seller_id: current_user.id)
    @line_items = LineItem.where(product_id: @products.pluck(:id)).where.not(order_id: nil)
    @order_ids = @line_items.pluck(:order_id).uniq
    @orders = Order.where(id: @order_ids)
    @order_details = {}
    @orders.reverse_each do |order|
      order_line_items = []
      associated_line_items = @line_items.where(order_id: order.id)
      associated_line_items.each do |line_item|
        product = Product.find(line_item.product_id)
        order_line_items << {
          id: line_item.id,
          product_name: product.name,
          line_item_quantity: line_item.quantity,
          status: line_item.status
        }
      end
      @order_details[order.id] = order_line_items
    end
  end




  def approve
    line_item = LineItem.find_by(id: params[:id])
    if line_item
      if line_item.update(status: "Dispatched")
        flash.now[:notice] = "Line item status updated successfully."
      else
        flash.now[:alert] = "Failed to update line item: #{line_item.errors.full_messages.join(", ")}"
      end
    @order=order_refresh(line_item.order)
    else
      flash.now[:alert] = "Line item not found."
    end
    redirect_to order_requests_orders_path
  end

  def seller_cancel
    line_item = LineItem.find_by(id: params[:id])
    if line_item
      if line_item.update(status: "Cancelled")
        line_item.product.update(stock_quantity: line_item.product.stock_quantity+line_item.quantity)
        flash.now[:notice] = "Line item status updated successfully."
      else
        flash.now[:alert] = "Failed to update line item: #{line_item.errors.full_messages.join(", ")}"
      end
      @order=order_refresh(line_item.order)
    else
      flash.now[:alert] = "Line item not found."
    end
    redirect_to order_requests_orders_path
  end

  def destroy
    @order=Order.find(params[:id])
    if @order.update(status: "Cancelled")
      @order.line_items.update(status: "Cancelled")
      @order.line_items.each do |line_item|
        line_item.product.update(stock_quantity: line_item.quantity+line_item.product.stock_quantity)
      end
      redirect_to orders_path
    else
      flash[:alert]="There was a problem cancelling the order !"
    end
  end

  private
  def order_params
    params.require(:order).permit(:total_price, :status)
  end


  def set_order
    @order = Order.find_by(id: params[:id])
    if !@order
      flash.now[:alert] = "Order not found."
      redirect_to root_path
    end
  end

  def user_authorize
    unless current_user&.seller?
      redirect_to root_path
    end
  end
end
