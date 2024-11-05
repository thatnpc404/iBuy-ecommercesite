class ProductsController < ApplicationController
  def index
    query = params[:query].presence || "*"
    conditions = {}
    conditions[:category_id] = params[:category_id] if params[:category_id].present?
    conditions[:seller_id] = params[:seller_id] if params[:seller_id].present?
    conditions[:seller_id] = current_user.id if conditions[:seller_id].nil? && current_user&.seller?
    @seller=User.find(conditions[:seller_id]) if conditions[:seller_id].present?
    sort_option = (params[:sort] == "desc" ? { price: :desc } : { price: :asc }) if params[:sort].present?
    if params[:clear]=="true"
      conditions={}
    end
    @products = Product.search(query, where: conditions, order: sort_option, page: params[:page], per_page: 8)
  end

  def show
    @product = Product.find(params[:id])
    @seller = @product.seller
    if current_user&.customer?
      @cart = Cart.find_by(user_id: current_user.id)
      @line_items = @cart.line_items.includes(:product)
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
    if @product.discard  # changed destroy to discarded
      flash.now[:notice] = "Product successfully deleted."
      redirect_to products_path
    else
      flash.now[:alert] = "Error deleting the product."
      render :show
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


  # def seller_products
  #   @seller=User.find(params[:id])
  #   @products=@seller.products
  # end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :img, :stock_quantity, :category_id).merge(seller_id: current_user.id)
  end
end
