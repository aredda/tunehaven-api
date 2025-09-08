# frozen_string_literal: true

class AddSlugToAlbums < ActiveRecord::Migration[8.0]
  def change
    add_column :platform_albums, :slug, :citext, null: true
  end
end
