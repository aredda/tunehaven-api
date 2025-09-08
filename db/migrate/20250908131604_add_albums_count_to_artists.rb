# frozen_string_literal: true

class AddAlbumsCountToArtists < ActiveRecord::Migration[8.0]
  def change
    add_column :platform_artists, :albums_count, :integer, default: 0
  end
end
