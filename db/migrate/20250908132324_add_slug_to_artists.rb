# frozen_string_literal: true

class AddSlugToArtists < ActiveRecord::Migration[8.0]
  def change
    enable_extension "citext"

    add_column :platform_artists, :slug, :citext, null: true
  end
end
