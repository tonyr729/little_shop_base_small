# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190103033507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: false
    t.decimal "price"
    t.text "description"
    t.string "image"
    t.integer "inventory"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "merchant_id"
    t.string "slug", default: "t"
    t.index ["merchant_id"], name: "index_items_on_merchant_id"
    t.index ["slug"], name: "index_items_on_slug"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "item_id"
    t.integer "quantity"
    t.decimal "price"
    t.boolean "fulfilled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_order_items_on_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.integer "role", default: 0
    t.boolean "active", default: true
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", default: "t"
    t.index ["city"], name: "index_users_on_city"
    t.index ["email"], name: "index_users_on_email"
    t.index ["slug"], name: "index_users_on_slug"
    t.index ["state"], name: "index_users_on_state"
  end

  add_foreign_key "items", "users", column: "merchant_id"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
end
