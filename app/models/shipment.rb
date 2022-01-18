class Shipment < ApplicationRecord
  has_many :shipping_products, dependent: :destroy
  has_many :products, through: :shipping_products

  validates :tracking_number, presence: true, uniqueness: true, allow_blank: false

  def destroy_with_return_items!
    Shipment.transaction do
      shipping_products.each(&:destroy_with_return_items!)
      destroy!
    end
  end
end
