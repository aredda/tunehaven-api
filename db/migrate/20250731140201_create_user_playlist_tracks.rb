# frozen_string_literal: true

class CreateUserPlaylistTracks < ActiveRecord::Migration[8.0]
  def change
    create_table :user_playlist_tracks do |t|
      t.uuid :playlist_id, null: false
      t.uuid :track_id, null: false
      t.integer :position, default: 1

      t.foreign_key :user_playlists, column: :playlist_id, on_delete: :cascade
      t.foreign_key :platform_tracks, column: :track_id, on_delete: :cascade

      t.index [ :playlist_id, :track_id ], unique: true

      t.timestamps
    end
  end
end
