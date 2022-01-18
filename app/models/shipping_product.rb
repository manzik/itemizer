class ShippingProduct < ApplicationRecord
  belongs_to :shipment
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates_uniqueness_of :shipment_id, scope: :product_id, message: "already contains this product"

  after_validation :verify_stock, on: [:create, :update]
  after_save :fulfill_shipment

  # Destroy items and return them to the stock at the same time.
  def destroy_with_return_items!
    ShippingProduct.transaction do
      return_items_to_stock!
      destroy!
    end
  end

  private
  # Return the items to the stock before destroying the shipment.
  def return_items_to_stock!
    product.increment!(:quantity, quantity)
  end

  # Make sure the product has enough stock to fulfill the shipment.
  def verify_stock
    @quantity_difference = quantity
    @quantity_difference -= quantity_was if persisted?
    
    if errors.empty? && product.quantity < @quantity_difference
      errors.add(:quantity, "is greater than the available stock")
    end
  end

  # Update the product's quantity in the inventory after a shipment is fulfilled.
  def fulfill_shipment
    product.decrement!(:quantity, @quantity_difference)
  end
end
