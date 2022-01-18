require "test_helper"

class ShippingProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shipping_product = shipping_products(:one)
    @product = products(:one)
    @shipment = shipments(:two)
  end

  test "should get index" do
    get api_v1_shipping_products_url, as: :json
    assert_response :success
  end

  test "should create shipping_product" do
    assert_difference("ShippingProduct.count") do
      post api_v1_shipping_products_url, params: { 
        shipping_product: { shipment_id: @shipment.id, product_id: @product.id, quantity: 3 } 
      }, as: :json
    end

    assert_response :created
  end

  test "create out of stock should return error" do
    post api_v1_shipping_products_url, params: { 
      shipping_product: { shipment_id: @shipment.id, product_id: @product.id, quantity: 50 } 
    }, as: :json
    assert_response :unprocessable_entity
    # Make sure the response contains at least one error message
    assert_not_empty @response.parsed_body["errors"]
  end

  test "should show shipping_product" do
    get api_v1_shipping_product_url(@shipping_product), as: :json
    assert_response :success
  end

  test "should update shipping_product" do
    patch api_v1_shipping_product_url(@shipping_product), params: { shipping_product: { quantity: 10 } }, as: :json
    assert_response :success
  end

  test "update out of stock should return error" do
    patch api_v1_shipping_product_url(@shipping_product), params: { shipping_product: { quantity: 60 } }, as: :json
    assert_response :unprocessable_entity
    # Make sure the response contains at least one error message
    assert_not_empty @response.parsed_body["errors"]
  end

  test "should destroy shipping_product" do
    assert_difference("ShippingProduct.count", -1) do
      delete api_v1_shipping_product_url(@shipping_product), as: :json
    end

    assert_response :no_content
  end
end
