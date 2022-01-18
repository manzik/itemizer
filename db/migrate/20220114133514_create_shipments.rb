class CreateShipments < ActiveRecord::Migration[7.0]
  def change
    create_table :shipments do |t|
      t.string :tracking_number, index: { unique: true }
      t.string :recipient_name
      t.string :recipient_email
      t.text :recipient_address

      t.timestamps
    end
  end
end
