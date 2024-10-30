class ProductsController < ApplicationController
  before_action :admin_authorize

  def index
      query = params[:query].presence || "*"
      conditions = {}
      conditions[:category_id] = params[:category_id] if params[:category_id].present?
      sort_option = (params[:sort] == "desc" ? { price: :desc } : { price: :asc }) if params[:sort].present?
      @products = Product.search(query, where: conditions, order: sort_option, page: params[:page], per_page: 8)
  end

  def show
    @product = Product.find(params[:id])
    @seller = @product.seller
    if current_user&.user?
      @cart = Cart.find_by(user_id: current_user.id)
      @line_items = @cart.line_items.includes(:product)
    else
      @cart = nil
      @line_items = nil
    end
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path, notice: "Product was successfully updated."
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.seller_id == current_user.id
      @product.destroy
      flash.now[:notice] = "Product successfully deleted."
      redirect_to sellers_path
    else
      flash.now[:alert] = "You are not authorized to delete this product."
      redirect_to products_path
    end
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash.now[:notice] = "Product created successfully!"
      redirect_to products_path
    else
      flash.now[:alert] = "There was a problem creating the product."
      redirect_to new_product_path
    end
  end


  def seller_products
    session.delete(:seller)
    @seller=User.find(params[:id])
    @products=@seller.products
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :img_url, :stock_quantity, :category_id).merge(seller_id: current_user.id)
  end

  def admin_authorize
    if current_user&.admin?
      redirect_to admins_path
    end
  end
end
