# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_14_133911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "quantity", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["quantity"], name: "index_products_on_quantity"
    t.check_constraint "quantity >= 0"
  end

  create_table "shipments", force: :cascade do |t|
    t.string "tracking_number"
    t.string "recipient_name"
    t.string "recipient_email"
    t.text "recipient_address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tracking_number"], name: "index_shipments_on_tracking_number", unique: true
  end

  create_table "shipping_products", force: :cascade do |t|
    t.bigint "shipment_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id", "shipment_id"], name: "index_shipping_products_on_product_id_and_shipment_id", unique: true
    t.index ["product_id"], name: "index_shipping_products_on_product_id"
    t.index ["shipment_id", "product_id"], name: "index_shipping_products_on_shipment_id_and_product_id", unique: true
    t.index ["shipment_id"], name: "index_shipping_products_on_shipment_id"
    t.check_constraint "quantity >= 1"
  end

  add_foreign_key "shipping_products", "products"
  add_foreign_key "shipping_products", "shipments"
end
