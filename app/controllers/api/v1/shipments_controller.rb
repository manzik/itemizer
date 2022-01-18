module Api
  module V1
    class ShipmentsController < ApplicationController
      before_action :set_shipment, only: %i[ show update destroy ]

      # GET /shipments
      def index
        @shipments = Shipment.all

        render_result json: @shipments
      end

      # GET /shipments/1
      def show
        render_result json: @shipment
      end

      # POST /shipments
      def create
        @shipment = Shipment.new(shipment_params)

        if @shipment.save
          render_result json: @shipment, status: :created, location: api_v1_shipment_url(@shipment)
        else
          render_errors json: @shipment.errors.full_messages
        end
      end

      # PATCH/PUT /shipments/1
      def update
        if @shipment.update(shipment_params)
          render_result json: @shipment
        else
          render_errors json: @shipment.errors.full_messages
        end
      end

      # DELETE /shipments/1
      def destroy
        success = false
        if params[:return_items] == "true"
          success = @shipment.destroy_with_return_items!
        else
          success = @shipment.destroy
        end
        if success
          head :no_content
        else
          render_errors json: @shipment.errors.full_messages
        end
      end

      private

        # Use callbacks to share common setup or constraints between actions.
        def set_shipment
          @shipment = Shipment.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def shipment_params
          params
            .require(:shipment)
            .permit(:tracking_number, :recipient_name, :recipient_email, :recipient_address)
        end
    end
  end
end