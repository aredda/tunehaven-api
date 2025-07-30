# frozen_string_literal: true

class CreatePlatformAlbumGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :platform_album_genres do |t|
      t.string :genre_id
      t.uuid :album_id

      t.foreign_key :platform_genres, column: :genre_id
      t.foreign_key :platform_albums, column: :album_id

      t.timestamps
    end
  end
end
