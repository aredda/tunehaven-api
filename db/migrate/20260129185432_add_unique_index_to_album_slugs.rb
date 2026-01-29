# frozen_string_literal: true

class AddUniqueIndexToAlbumSlugs < ActiveRecord::Migration[8.0]
  def change
    add_index :platform_albums, :slug, unique: true
  end
end
