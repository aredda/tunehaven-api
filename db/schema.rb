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

ActiveRecord::Schema[8.0].define(version: 2025_07_31_150322) do
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

  create_table "platform_track_genres", force: :cascade do |t|
    t.string "genre_id", null: false
    t.uuid "track_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platform_tracks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "title", null: false
    t.integer "duration_in_seconds", null: false
    t.uuid "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_jwt_denylists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_user_jwt_denylists_on_jti"
  end

  create_table "user_playlist_tracks", force: :cascade do |t|
    t.uuid "playlist_id", null: false
    t.uuid "track_id", null: false
    t.integer "position", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id", "track_id"], name: "index_user_playlist_tracks_on_playlist_id_and_track_id", unique: true
  end

  create_table "user_playlists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.string "visibility", default: "private"
    t.integer "tracks_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "username", null: false
    t.citext "email", null: false
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "platform_album_genres", "platform_albums", column: "album_id"
  add_foreign_key "platform_album_genres", "platform_genres", column: "genre_id"
  add_foreign_key "platform_albums", "platform_artists", column: "artist_id"
  add_foreign_key "platform_artist_genres", "platform_artists", column: "artist_id"
  add_foreign_key "platform_artist_genres", "platform_genres", column: "genre_id"
  add_foreign_key "platform_track_genres", "platform_genres", column: "genre_id"
  add_foreign_key "platform_track_genres", "platform_tracks", column: "track_id"
  add_foreign_key "platform_tracks", "platform_albums", column: "album_id"
  add_foreign_key "user_playlist_tracks", "platform_tracks", column: "track_id", on_delete: :cascade
  add_foreign_key "user_playlist_tracks", "user_playlists", column: "playlist_id", on_delete: :cascade
  add_foreign_key "user_playlists", "users", on_delete: :cascade
end
