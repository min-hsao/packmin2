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

ActiveRecord::Schema[7.1].define(version: 2024_01_01_000005) do
  create_table "activities", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "associated_items"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_activities_on_user_id_and_name"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "custom_items", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "category", null: false
    t.decimal "volume_liters", precision: 6, scale: 2
    t.boolean "always_pack", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "always_pack"], name: "index_custom_items_on_user_id_and_always_pack"
    t.index ["user_id", "category"], name: "index_custom_items_on_user_id_and_category"
    t.index ["user_id"], name: "index_custom_items_on_user_id"
  end

  create_table "packing_lists", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "destinations", null: false
    t.text "traveler_info", null: false
    t.text "generated_list"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_packing_lists_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_packing_lists_on_user_id"
  end

  create_table "saved_locations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "address", null: false
    t.text "default_activities"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_saved_locations_on_user_id_and_name"
    t.index ["user_id"], name: "index_saved_locations_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "avatar_url"
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "ai_provider"
    t.text "ai_api_key"
    t.text "openweather_api_key"
    t.boolean "setup_completed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  add_foreign_key "activities", "users"
  add_foreign_key "custom_items", "users"
  add_foreign_key "packing_lists", "users"
  add_foreign_key "saved_locations", "users"
end
