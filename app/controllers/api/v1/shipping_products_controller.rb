module Api
  module V1
    class ShippingProductsController < ApplicationController
      before_action :set_shipping_product, only: %i[ show update destroy ]

      # GET /shipping_products
      def index
        @shipping_products = ShippingProduct.all

        render_result json: @shipping_products
      end

      # GET /shipping_products/1
      def show
        render_result json: @shipping_product
      end

      # POST /shipping_products
      def create
        @shipping_product = ShippingProduct.new(shipping_product_params)

        if @shipping_product.save
          render_result json: @shipping_product, status: :created
        else
          render_errors json: @shipping_product.errors.full_messages
        end
      end

      # PATCH/PUT /shipping_products/1
      def update
        if @shipping_product.update(shipping_product_params)
          render_result json: @shipping_product
        else
          render_errors json: @shipping_product.errors.full_messages
        end
      end

      # DELETE /shipping_products/1
      def destroy
        success = false
        if params[:return_items] == "true"
          success = @shipping_product.destroy_with_return_items!
        else
          success = @shipping_product.destroy
        end
        if success
          head :no_content
        else
          render_errors json: @shipping_product.errors.full_messages
        end
      end

      private

        # Use callbacks to share common setup or constraints between actions.
        def set_shipping_product
          @shipping_product = ShippingProduct.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def shipping_product_params
          params.require(:shipping_product).permit(:quantity, :product_id, :shipment_id)
        end
    end
  end
end