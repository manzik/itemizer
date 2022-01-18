class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, index: { unique: true }
      t.text :description
      # Index since we'll probably be using this field for filtering
      t.integer :quantity, :default => 0, index: true
      t.check_constraint "quantity >= 0"

      t.timestamps
    end
  end
end
