class InventoryItem < ApplicationRecord
  validates :name, presence: true, uniqueness: true, allow_blank: false
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
