# frozen_string_literal: true


class CreatePlatformAlbums < ActiveRecord::Migration[8.0]
  def change
    create_table :platform_albums, id: :uuid do |t|
      t.citext :title, null: false
      t.uuid :artist_id, null: false
      t.string :cover, null: true
      t.date :release_date, null: true
      t.integer :tracks_count, null: false, default: 0

      t.foreign_key :platform_artists, column: :artist_id

      t.timestamps
    end
  end
end
