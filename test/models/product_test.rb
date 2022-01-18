require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "should not save without title" do
    product = Product.new
    assert_not product.save
  end

  test "should not save negative quantity" do
    product = Product.new
    product.name = "Test Product"
    product.quantity = -1
    assert_not product.save
  end

  test "should save" do
    product = Product.new
    product.name = "Test Product"
    product.quantity = 0
    assert product.save
    
    product.quantity = 1
    assert product.save
  end
end
