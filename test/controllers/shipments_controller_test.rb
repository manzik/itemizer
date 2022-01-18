require "test_helper"

class ShipmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shipment = shipments(:two)
    @product = products(:one)
  end

  test "should get index" do
    get api_v1_shipments_url, as: :json
    assert_response :success
  end

  test "should create shipment" do
    assert_difference("Shipment.count") do
      post api_v1_shipments_url, params: { 
        shipment: { recipient_address: @shipment.recipient_address, recipient_email: @shipment.recipient_email, tracking_number: "121958-671155-131932" }
      }, as: :json
    end

    assert_response :created
  end

  test "should show shipment" do
    get api_v1_shipment_url(@shipment), as: :json
    assert_response :success
  end

  test "should update shipment" do
    patch api_v1_shipment_url(@shipment), params: { shipment: { recipient_address: @shipment.recipient_address, recipient_email: @shipment.recipient_email, tracking_number: @shipment.tracking_number } }, as: :json
    assert_response :success
  end

  test "should destroy shipment" do
    assert_difference("Shipment.count", -1) do
      delete api_v1_shipment_url(@shipment), as: :json
    end

    assert_response :no_content
  end
end
