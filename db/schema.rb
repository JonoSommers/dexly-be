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

ActiveRecord::Schema[8.0].define(version: 2025_05_20_164904) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "binder_cards", force: :cascade do |t|
    t.bigint "binder_id", null: false
    t.string "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["binder_id"], name: "index_binder_cards_on_binder_id"
  end

  create_table "binders", force: :cascade do |t|
    t.string "name"
    t.string "cover_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "set_name"
    t.string "image_url"
    t.string "supertype"
    t.string "subtype"
    t.string "rarity"
    t.string "types"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cards_on_name"
    t.index ["set_name"], name: "index_cards_on_set_name"
  end

  create_table "user_binders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "binder_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["binder_id"], name: "index_user_binders_on_binder_id"
    t.index ["user_id"], name: "index_user_binders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "binder_cards", "binders"
  add_foreign_key "binder_cards", "cards"
  add_foreign_key "user_binders", "binders"
  add_foreign_key "user_binders", "users"
end
