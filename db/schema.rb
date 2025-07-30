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

ActiveRecord::Schema[8.0].define(version: 2025_07_30_154505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  create_table "platform_album_genres", force: :cascade do |t|
    t.string "genre_id"
    t.uuid "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platform_albums", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "title", null: false
    t.uuid "artist_id", null: false
    t.string "cover"
    t.date "release_date"
    t.integer "tracks_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platform_artist_genres", force: :cascade do |t|
    t.uuid "artist_id", null: false
    t.string "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platform_artists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "name", null: false
    t.text "about"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platform_genres", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "platform_album_genres", "platform_albums", column: "album_id"
  add_foreign_key "platform_album_genres", "platform_genres", column: "genre_id"
  add_foreign_key "platform_albums", "platform_artists", column: "artist_id"
  add_foreign_key "platform_artist_genres", "platform_artists", column: "artist_id"
  add_foreign_key "platform_artist_genres", "platform_genres", column: "genre_id"
end
