class CreateShippingProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_products do |t|
      t.belongs_to :shipment, null: false, foreign_key: true, on_delete: :cascade
      t.belongs_to :product, null: false, foreign_key: true, on_delete: :restrict
      t.integer :quantity, null: false
      t.check_constraint "quantity >= 1"
      t.index [:shipment_id, :product_id], :unique => true
      t.index [:product_id, :shipment_id], :unique => true

      t.timestamps
    end
  end
end
