module Api
  module V1
    class ShipmentSerializer < ActiveModel::Serializer
      type "shipment"

      attributes :id, :tracking_number, :recipient_name, :recipient_email, :recipient_address

      has_many :shipping_products do
        self.object.shipping_products.map do |shipping_product|
          shipping_product.slice(:id, :quantity, :product)
        end
      end
    end
  end
end