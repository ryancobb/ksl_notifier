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

ActiveRecord::Schema.define(version: 20171012023653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.text     "name"
    t.text     "search_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "listings", force: :cascade do |t|
    t.text     "title"
    t.text     "short_description"
    t.text     "full_description"
    t.text     "location"
    t.text     "link"
    t.integer  "price_cents",       default: 0,     null: false
    t.string   "price_currency",    default: "USD", null: false
    t.date     "posted_on"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "item_id"
    t.text     "photo_url"
    t.index ["link", "item_id"], name: "index_listings_on_link_and_item_id", unique: true, using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "listing_id"
    t.text     "message"
    t.boolean  "dismissed"
    t.boolean  "emailed"
    t.boolean  "sms_sent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "item_id"
    t.index ["item_id"], name: "index_notifications_on_item_id", using: :btree
    t.index ["listing_id"], name: "index_notifications_on_listing_id", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.string   "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "notifications", "items"
  add_foreign_key "notifications", "listings"
  add_foreign_key "notifications", "users"
end
