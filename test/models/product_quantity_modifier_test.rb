class ProductQuantityModifierTest < ActiveSupport::TestCase
  setup do
    @product = Product.new
    @product.name = "Test Product"
    @product.quantity = 10
    @product.save!

    @shipment = Shipment.new
    @shipment.tracking_number = "141501-709952-819009"
    @shipment.save!

    # pairs of (shipment_key, shipping_items_quantity)
    shipping_items_quantities = {
      one: 1,
      two: 2
    }

    # Ship the products
    @shipping_products = []
    shipping_items_quantities.each_with_index do |(shipment_key, shipping_items_quantity), index|
      assert ship_product(@product, shipments(shipment_key), shipping_items_quantity)
      @shipping_products << @shipping_product
    end

    @product.reload
    @shipment.reload
  end

  def ship_product(product, shipment, quantity)
    @shipping_product = ShippingProduct.new product: product, shipment: shipment, quantity: quantity
    @shipping_product.save
  end
end