class CreateInventoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_items do |t|
      t.string :name, index: { unique: true }
      t.text :description
      t.integer :quantity, :default => 0
      t.check_constraint "quantity >= 0" 

      t.timestamps
    end
  end
end
