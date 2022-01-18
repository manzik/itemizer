require "test_helper"

class ShipmentTest < ProductQuantityModifierTest
  test "should not save without tracking number" do
    shipment = Shipment.new
    assert_not shipment.save
  end

  test "should not save with empty tracking number" do
    shipment = Shipment.new
    shipment.tracking_number = ""
    assert_not shipment.save
  end

  test "should not save with non-unique tracking numbers" do
    shipment = Shipment.new
    shipment.tracking_number = "1234567890"
    assert shipment.save

    shipment = Shipment.new
    shipment.tracking_number = "1234567890"
    assert_not shipment.save
  end

  test "should save" do
    shipment = Shipment.new
    shipment.tracking_number = "121958-671155-131932"
    assert shipment.save
  end

  test "should destroy shipment with returning items to stock" do
    assert_difference("@product.reload.quantity", @shipment.shipping_products.pluck(:quantity).sum) do
      assert @shipment.destroy_with_return_items!
    end
  end

  test "should destroy shipment without returning items to stock" do
    assert_no_difference "@product.reload.quantity" do
      assert @shipment.destroy
    end
  end
end
