module Api
  module V1
    class ProductSerializer < ActiveModel::Serializer
      type "product"

      attributes :id, :name, :description, :quantity
      
      has_many :shipping_products
    end
  end
end
