# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_29_035533) do

  create_table "clients", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "company_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customer_addresses", force: :cascade do |t|
    t.string "shopify_address_id"
    t.string "shopify_customer_id"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "company"
    t.string "country", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "province"
    t.string "zip"
    t.string "name"
    t.string "country_code", null: false
    t.integer "address_type", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_type"], name: "index_customer_addresses_on_address_type"
    t.index ["deleted_at"], name: "index_customer_addresses_on_deleted_at"
    t.index ["shopify_address_id"], name: "index_customer_addresses_on_shopify_address_id"
    t.index ["shopify_customer_id"], name: "index_customer_addresses_on_shopify_customer_id"
  end

  create_table "event_logs", force: :cascade do |t|
    t.string "type", null: false
    t.string "internal_name", null: false
    t.string "group", null: false
    t.string "controller"
    t.string "action"
    t.string "params"
    t.string "method"
    t.string "path"
    t.string "status"
    t.string "status_message"
    t.string "exception_message"
    t.string "exception_line"
    t.string "exception_stack"
    t.string "remote_address"
    t.string "manual_status"
    t.datetime "deleted_at"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "gdpr_requests", force: :cascade do |t|
    t.string "shop_id", null: false
    t.string "shop_domain", null: false
    t.string "shopify_customer_id"
    t.string "email"
    t.string "phone"
    t.string "type"
    t.text "orders"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "integrations_upwork_clients", force: :cascade do |t|
    t.string "messages_room_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "client_id"
    t.index ["client_id"], name: "index_integrations_upwork_clients_on_client_id"
  end

  create_table "order_line_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.string "shopify_line_item_id", null: false
    t.decimal "price", precision: 8, scale: 2
    t.string "shopify_product_id"
    t.integer "quantity", null: false
    t.string "name", null: false
    t.string "sku"
    t.integer "grams"
    t.string "title", null: false
    t.string "shopify_variant_id"
    t.string "variant_title"
    t.integer "fulfillable_quantity"
    t.string "fulfillment_service"
    t.string "fulfillment_status"
    t.boolean "product_exists"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_line_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "shopify_order_id", null: false
    t.integer "billing_address_id"
    t.integer "shipping_address_id"
    t.string "cancel_reason"
    t.datetime "cancelled_at"
    t.datetime "closed_at"
    t.string "currency", null: false
    t.string "shopify_customer_id", null: false
    t.string "email", null: false
    t.string "financial_status"
    t.string "fulfillment_status"
    t.string "name", null: false
    t.text "note"
    t.string "number", null: false
    t.string "order_number", null: false
    t.string "phone"
    t.datetime "processed_at"
    t.string "refunds"
    t.decimal "subtotal_price", precision: 8, scale: 2, null: false
    t.boolean "taxes_included"
    t.string "token"
    t.decimal "total_discounts", precision: 8, scale: 2
    t.decimal "total_line_items_price", precision: 8, scale: 2, null: false
    t.decimal "total_price", precision: 8, scale: 2, null: false
    t.decimal "total_tax", precision: 8, scale: 2
    t.integer "total_weight"
    t.string "order_status_url"
    t.datetime "deleted_at"
    t.text "note_attributes"
    t.string "tags"
    t.integer "colorcentric_status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "colorcentric_status_text", default: "", null: false
    t.text "colorcentric_xml_response"
    t.text "colorcentric_details", default: "{}", null: false
    t.index ["billing_address_id"], name: "index_orders_on_billing_address_id"
    t.index ["colorcentric_status"], name: "index_orders_on_colorcentric_status"
    t.index ["shipping_address_id"], name: "index_orders_on_shipping_address_id"
    t.index ["shopify_order_id"], name: "index_orders_on_shopify_order_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "supplier_part_id", null: false
    t.string "supplier_part_auxiliary_id", null: false
    t.decimal "price", precision: 8, scale: 2, null: false
    t.string "print_file_url", null: false
    t.integer "page_count"
    t.string "shopify_variant_id"
    t.string "shopify_product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "sku"
    t.index ["print_file_url"], name: "index_parts_on_print_file_url"
    t.index ["shopify_product_id"], name: "index_parts_on_shopify_product_id"
    t.index ["shopify_variant_id"], name: "index_parts_on_shopify_variant_id"
    t.index ["supplier_part_auxiliary_id"], name: "index_parts_on_supplier_part_auxiliary_id"
    t.index ["supplier_part_id"], name: "index_parts_on_supplier_part_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name", null: false
    t.string "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_settings_on_name"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  add_foreign_key "integrations_upwork_clients", "clients"
  add_foreign_key "order_line_items", "orders"
end
