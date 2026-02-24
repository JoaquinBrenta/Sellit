class ProductsController < ApplicationController
    include Pagy::Method

    skip_before_action :protect_pages, only: [:index, :show]
    
    def index
        @categories = Category.order(name: :asc).load_async
        @pagy, @products = pagy(:offset, FindProducts.new.call(product_params_index).load_async, limit: 12)
    end

    def show
        product
    end

    def new
        @product = Product.new
    end

    def create
        @product = Product.new(product_params)
        if @product.save
            redirect_to products_path, notice: 'Product was successfully created.'
        else
            render :new, status: :unprocessable_entity
        end
    end 

    def edit
        authorize! product
    end
    
    def update
        authorize! product
        if product.update(product_params)
            notify_all_users
            redirect_to products_path, notice: 'Product was successfully updated.'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        authorize! product
        product.destroy
        notify_all_users
        redirect_to products_path, notice: 'Product was successfully destroyed.'
    end


    private 
    def product_params
        params.require(:product).permit(:title, :description, :price, :image, :category_id)
    end

    def product_params_index
        params.permit(:category_id, :min_price, :max_price, :image, :search, :order_by, :page, :favorites, :user_id)
    end

    def product
        @product ||= Product.find(params[:id])
    end

    def notify_all_users
        ActionCable.server.broadcast(
            "product_#{product.id}",
            {
                action: "update",
            }
        )
    end
end