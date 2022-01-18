require "test_helper"

class ShippingProductTest < ProductQuantityModifierTest
  test "should not save non-positive quantities" do
    assert_not ship_product(@product, @shipment, -5)
    assert_not ship_product(@product, @shipment, 0)
  end

  test "create should decrement product quantity" do
    shipping_items_quantity = 3

    assert_difference("@product.reload.quantity", -shipping_items_quantity) do
      assert ship_product(@product, @shipment, shipping_items_quantity)
    end
  end

  test "update should reflect on product quantity" do
    @shipping_products.each_with_index do |shipping_product, index|
      # Each deleted shipping product's quantity should be added back to inventory
      assert_difference "@product.reload.quantity", -index do
        shipping_product.quantity += index
        assert shipping_product.save!
      end
      assert_difference "@product.reload.quantity", index do
        shipping_product.quantity -= index
        assert shipping_product.save!
      end
    end
  end

  test "emptying stock should succeed" do
    assert ship_product(@product, @shipment, @product.quantity)
  end

  test "adding more items than in stock should throw error" do
    assert_not ship_product(@product, @shipment, @product.quantity + 1)
  end

  test "destroy shipping_product with returning items to stock" do
    # Ship the products
    @shipping_products.each_with_index do |shipping_product, index|
      # Each deleted shipping product's quantity should be added back to inventory
      assert_difference "@product.reload.quantity", shipping_product.quantity do
        assert shipping_product.destroy_with_return_items!
      end
    end
  end

  test "destroy shipping_product without returning items to stock" do
    @shipping_products.each_with_index do |shipping_product, index|
      # Destroying shipping products should not affect the product's quantity
      assert_no_difference "@product.reload.quantity" do
        assert shipping_product.destroy
      end
    end
  end
end
