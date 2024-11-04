class AddressesController < ApplicationController
  def index
    @source = params[:source] || "profile"
    @addresses=current_user.addresses
  end

  def new
    @address=Address.new
  end

  def create
      @user=User.find(current_user.id)
      @address=@user.addresses.new(address_params)
      if @address.save
        redirect_to payment_orders_path("address_id": @address.id)
      else
        flash.now[:alert] = @address.errors.full_messages.to_sentence
        render :new
      end
  end
  def destroy
    @address=Address.find(params[:id])
    if @address.destroy
      redirect_to addresses_path
    end
  end
  def checkout
    @order=Order.new
    @cart = Cart.find_by(user_id: current_user.id)
    @line_items = @cart.line_items.includes(:product) if @cart
  end

  def edit
    @address=Address.find(params[:id])
  end

  def update
    @address=Address.find(params[:id])
    if @address.update(address_params)
      redirect_to addresses_path, notice: "Address was successfully updated."
    else
      render :edit
    end
  end

  private

  def address_params
    params.require(:address).permit(:shipping_address, :state, :city, :zip_code, :country)
  end
end
