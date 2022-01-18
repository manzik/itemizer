require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get api_v1_products_url, as: :json
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post api_v1_products_url, params: { product: { name: "Sandwich" } }, as: :json
    end

    assert_response :created
  end

  test "should show product" do
    get api_v1_product_url(@product), as: :json
    assert_response :success
  end

  test "should update product" do
    patch api_v1_product_url(@product), params: { product: { name: "Jelly" } }, as: :json
    assert_response :success
  end

  test "should destroy product without dependent shipments" do
    @product.shipping_products.destroy_all
    assert_difference("Product.count", -1) do
      delete api_v1_product_url(@product), as: :json
    end
    assert_response :no_content
  end

  test "should not destroy product with dependent shipments" do
    delete api_v1_product_url(@product), as: :json
    assert_response :unprocessable_entity
  end
end
