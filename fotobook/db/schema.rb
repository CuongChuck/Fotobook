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

ActiveRecord::Schema[8.0].define(version: 2025_07_17_014500) do
  create_table "album_has_photo", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "album_id"
    t.bigint "photo_id"
    t.index ["album_id"], name: "index_album_has_photo_on_album_id"
    t.index ["photo_id"], name: "index_album_has_photo_on_photo_id"
  end

  create_table "albums", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "user_id"
    t.boolean "isPublic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "photos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "url"
    t.bigint "user_id"
    t.bigint "person_id"
    t.boolean "isPublic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_photos_on_person_id"
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "user_like_album", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "album_id"
    t.index ["album_id"], name: "index_user_like_album_on_album_id"
    t.index ["user_id"], name: "index_user_like_album_on_user_id"
  end

  create_table "user_like_photo", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "photo_id"
    t.index ["photo_id"], name: "index_user_like_photo_on_photo_id"
    t.index ["user_id"], name: "index_user_like_photo_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.string "email"
    t.boolean "isActive", default: true
    t.string "password"
    t.boolean "isAdmin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "albums", "users"
  add_foreign_key "photos", "users"
  add_foreign_key "photos", "users", column: "person_id"
end
