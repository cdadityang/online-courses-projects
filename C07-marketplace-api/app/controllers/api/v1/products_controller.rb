class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update]
  
  respond_to :json
  
  def index
    #products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all
    #render json: products, status: :ok
    # render json: Product.search(params), status: :ok
    products = Product.search(params).page(params[:page]).per(params[:per_page])
    puts "-----"
    puts params[:per_page]
    puts params[:page]
    puts products
    render json: products, meta: pagination(products, params[:per_page]), status: :ok
  end
  
  def show
    render json: Product.find(params[:id]), status: :ok
  end
  
  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: product, status: 201, location: [:api, product]
    else
      render json: { errors: product.errors }, status: 422
    end
  end
  
  def update
    product = current_user.products.find(params[:id])
    if product.update(product_params)
      render json: product, status: :ok, location: [:api, product]
    else
      render json: { errors: product.errors }, status: 422
    end
  end
  
  def destroy
    product = current_user.products.find(params[:id])
    product.destroy
  end
  
  private
    def product_params
      params.require(:product).permit(:title, :price, :published)
    end
end
