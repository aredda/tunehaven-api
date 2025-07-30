# frozen_string_literal: true

class CreatePlatformTrackGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :platform_track_genres do |t|
      t.string :genre_id, null: false
      t.uuid :track_id, null: false

      t.foreign_key :platform_genres, column: :genre_id
      t.foreign_key :platform_tracks, column: :track_id

      t.timestamps
    end
  end
end
