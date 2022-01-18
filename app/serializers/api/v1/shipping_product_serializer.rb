module Api
  module V1
    class ShippingProductSerializer < ActiveModel::Serializer
      type "shipping_product"

      attributes :id, :quantity
      
      has_one :product
      has_one :shipment
    end
  end
end