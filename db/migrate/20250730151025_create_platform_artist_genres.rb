# frozen_string_literal: true

class CreatePlatformArtistGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :platform_artist_genres do |t|
      t.uuid :artist_id, null: false
      t.string :genre_id, null: false

      t.foreign_key :platform_genres, column: :genre_id
      t.foreign_key :platform_artists, column: :artist_id

      t.timestamps
    end
  end
end
