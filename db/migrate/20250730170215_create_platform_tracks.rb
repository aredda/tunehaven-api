# frozen_string_literal: true

class CreatePlatformTracks < ActiveRecord::Migration[8.0]
  def change
    create_table :platform_tracks, id: :uuid do |t|
      t.citext :title, null: false
      t.integer :duration_in_seconds, null: false
      t.uuid :album_id, null: true

      t.foreign_key :platform_albums, column: :album_id

      t.timestamps
    end
  end
end
