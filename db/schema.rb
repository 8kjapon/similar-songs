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

ActiveRecord::Schema[7.0].define(version: 2024_12_15_221305) do
  create_table "ahoy_events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.json "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "artists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_artists_on_name"
  end

  create_table "contacts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "message"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "similarity_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "song_artists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "artist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_song_artists_on_artist_id"
    t.index ["song_id", "artist_id"], name: "index_song_artists_on_song_id_and_artist_id", unique: true
    t.index ["song_id"], name: "index_song_artists_on_song_id"
  end

  create_table "song_pair_evaluations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "song_pair_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_pair_id"], name: "index_song_pair_evaluations_on_song_pair_id"
    t.index ["user_id", "song_pair_id"], name: "index_song_pair_evaluations_on_user_id_and_song_pair_id", unique: true
    t.index ["user_id"], name: "index_song_pair_evaluations_on_user_id"
  end

  create_table "song_pairs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "original_song_id", null: false
    t.bigint "similar_song_id", null: false
    t.text "original_song_description", null: false
    t.text "similar_song_description", null: false
    t.bigint "similarity_category_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["original_song_id", "similar_song_id"], name: "index_song_pairs_on_original_song_id_and_similar_song_id", unique: true
    t.index ["original_song_id"], name: "index_song_pairs_on_original_song_id"
    t.index ["similar_song_id"], name: "index_song_pairs_on_similar_song_id"
    t.index ["similarity_category_id"], name: "index_song_pairs_on_similarity_category_id"
    t.index ["user_id"], name: "index_song_pairs_on_user_id"
  end

  create_table "songs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.string "release_date"
    t.string "media_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_songs_on_title"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "general", null: false
    t.datetime "last_login_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "contacts", "users"
  add_foreign_key "song_artists", "artists"
  add_foreign_key "song_artists", "songs"
  add_foreign_key "song_pair_evaluations", "song_pairs"
  add_foreign_key "song_pair_evaluations", "users"
  add_foreign_key "song_pairs", "similarity_categories"
  add_foreign_key "song_pairs", "songs", column: "original_song_id"
  add_foreign_key "song_pairs", "songs", column: "similar_song_id"
  add_foreign_key "song_pairs", "users"
end
