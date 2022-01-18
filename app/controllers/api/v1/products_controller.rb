module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: %i[ show update destroy ]

      # GET /products
      def index
        @products = Product.all

        render_result json: @products
      end

      # GET /products/1
      def show
        render_result json: @product
      end

      # POST /products
      def create
        @product = Product.new(product_params)

        if @product.save
          render_result json: @product, status: :created, location: api_v1_product_url(@product)
        else
          render_errors json: @product.errors.full_messages
        end
      end

      # PATCH/PUT /products/1
      def update
        if @product.update(product_params)
          render_result json: @product
        else
          render_errors json: @product.errors.full_messages
        end
      end

      # DELETE /products/1
      def destroy
        if @product.destroy
          head :no_content
        else
          render_errors json: @product.errors.full_messages
        end
      end

      private
      
        # Use callbacks to share common setup or constraints between actions.
        def set_product
          @product = Product.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_params
          params.require(:product).permit(:name, :description, :quantity)
        end
    end
  end
end